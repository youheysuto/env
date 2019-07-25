source ~/.zplug/init.zsh

export PATH="/usr/local/opt/openssl/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/openssl/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include"
# CONFIGURE_OPTS="--with-openssl=$(brew --prefix openssl)" pyenv install 3.7.0


#################################################
# local settings
#################################################
autoload -U promptinit; promptinit
autoload -Uz colors
prompt pure
colors
setopt auto_cd
setopt correct
HISTFILE=$HOME/.zsh-history
HISTSIZE=1000000
SAVEHIST=1000000
setopt share_history
setopt auto_list 
setopt auto_menu

alias ll='ls -l'
alias la='ls -la'

#################################################
# zplug plugins
#################################################
# zplug "zsh-users/zsh-history-substring-search", defer:3
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-completions"
zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
zplug "junegunn/fzf", as:command, use:bin/fzf-tmux
zplug "rupa/z", use:z.sh
# zplug "b4b4r07/enhancd", use:init.sh
# zplug 'dracula/zsh', as:theme
if ! zplug check --verbose; then
	printf "Install? [y/N]: "
	if read -q; then
		echo; zplug install
	fi
fi
zplug load --verbose

#################################################
# tools
#################################################
# anyenv
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"
eval "$(pyenv virtualenv-init -)"

# using brew installed openssl
# export PATH=/usr/local/Cellar/openssl/1.0.2q/bin:$PATH
#
export GOPATH=${HOME}/go
export PATH=$GOPATH/bin:$PATH

# pyenv disable prompt
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# fzf settings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'

#################################################
# functions
#################################################
# aws configureで設定したアカウントのec2を対象に選択
# 起動, 停止, ssh-config書き換えを行う
# requirements
#   * aws cli (on pyenv python)
#   * aws fzf
#   * aws jq
# Name:hostname -> ~/.ssh/configのホストとリンクしている必要あり
# 1. ec2インスタンス情報一覧を取得
# 2. fzfに渡す
# 3. action 入力
function select-instance()  {
  pyenv global aws
  local tmppyenv=$(pyenv global)
  echo "pyenv global change $tmppyenv to aws"
  local selected=$(aws ec2 describe-instances \
    --query 'Reservations[].Instances[].{InstanceId:InstanceId,ServerName:KeyName,InstanceType:InstanceType,Status:State.Name}' |\
    jq -c '.[]'|fzf -m)
  local iid=$(echo $selected | jq -r '.[].InstanceId')

  if [ -z "$selected" ]; then
    echo "no fzf selected" 
    exit 1
  fi

  echo "========================="
  echo $selected | jq .
  echo "========================="
  read input\?'U(p), S(top), C(onfig):'
  case "$input" in
    "" ) echo "no selected ..." ;;
    U ) echo "Up" 
      aws ec2 start-instances --instance-ids $iid && aws ec2 wait instance-running --instance-ids $iid
      local hostname=$(echo $selected | jq -r '.[].ServerName')
      local dnsname=$(aws ec2 describe-instances --instance-ids $iid --query 'Reservations[0].Instances[0].PublicDnsName' |jq -r)
      echo start rewrite ~/.ssh/config ${dnsname}
      sed -i -e "N;s%\(Host ${hostname}.*HostName \).*$%\1${dnsname}%" ~/.ssh/config
      echo end rewrite ~/.ssh/config ${dnsname}
      ;;
    S ) echo "Stop" 
      aws ec2 stop-instances --instance-ids $iid && aws ec2 wait instance-stopped --instance-ids $iid
      ;;
    C ) echo "Config" 
      local hostname=$(echo $selected | jq -r '.[].ServerName')
      local dnsname=$(aws ec2 describe-instances --instance-ids $iid --query 'Reservations[0].Instances[0].PublicDnsName' |jq -r)
      echo start rewrite ~/.ssh/config ${dnsname}
      sed -i -e "N;s%\(Host ${hostname}.*HostName \).*$%\1${dnsname}%" ~/.ssh/config
      grep -e "${hostname}" -e "${dnsname}" ~/.ssh/config
      echo end rewrite ~/.ssh/config ${dnsname}
      ;;
    * ) echo "nothings todo" ;;
  esac
  pyenv global $tmppyenv
  echo "pyenv global return to $tmppyenv"
}

# 履歴の中からよくアクセスするdirectoryをfzfで選択してにcdする
fzf-z-search(){
  local res=$(z |sort -rn |cut -c 12- |fzf)
  if [ -n "$res" ]; then
    BUFFER+="cd $res"
    zle accept-line
  else
    return 1
  fi
}
zle -N fzf-z-search
bindkey '^o' fzf-z-search

