fpath=($fpath "$HOME/.zfunctions")
export GPG_TTY=$(tty)
export GEM_HOME="$HOME/.gem"

export DOCKER_BUILDKIT=1                                                                                                                                                    
export COMPOSE_DOCKER_CLI_BUILD=0
export DOCKER_DEFAULT_PLATFORM=linux/amd64

# Typewritten ZSH Prompt
export TYPEWRITTEN_PROMPT_LAYOUT="singleline"
export TYPEWRITTEN_SYMBOL="❯"   ## export TYPEWRITTEN_SYMBOL=""
export TYPEWRITTEN_ARROW_SYMBOL="->"
export TYPEWRITTEN_RELATIVE_PATH="adaptive"
export TYPEWRITTEN_CURSOR="block"
export TYPEWRITTEN_LEFT_PROMPT_PREFIX_FUNCTION=display_kube_context

display_kube_context() {
  tw_kube_context="$(kubectl config current-context 2> /dev/null)"

  if [[ $tw_kube_context != "" ]]; then
    echo "($(basename $tw_kube_context))"
  fi
}

export SHELL_SESSIONS_DISABLE=1

gpgconf --launch gpg-agent

alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

ssh-add -q $HOME/.ssh/*

# AutoJump
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

# iCloud Drive
alias ic='cd ~/Library/Mobile\ Documents/com~apple~CloudDocs'

autoload -U promptinit; promptinit
prompt typewritten

# Enable extended history with timestamps
setopt EXTENDED_HISTORY
# Prevent storing duplicates in the history
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
# Append history entries from multiple sessions
setopt INC_APPEND_HISTORY
# Customize the timestamp format
export HISTTIMEFORMAT="[%F %T]"
# Specify the location of the history file
export HISTFILE=~/.zhistory
# Set a generous limit for the history file size
export HISTFILESIZE=1000000000
# Set the maximum number of history entries to keep
export HISTSIZE=1000000000
# Ensure that history entries are saved up to HISTSIZE
export SAVEHIST=$HISTSIZE

function xman() { open x-man-page://$@ ; } # macos visual manpage
alias curltime="curl -w \"@$HOME/.curl-format.txt\" -o /dev/null -s "

## Kubectl List API Resources ##
function kubectlgetall {
  echo "usage: kubectlgetall namespace"
  if [ $# -eq 0 ]; then
    return
  fi
  for i in $(kubectl api-resources --verbs=list --namespaced -o name | grep -v "events.events.k8s.io" | grep -v "events" | sort | uniq); do echo "Resource: $i" && kubectl get ${i} -n ${1} --ignore-not-found=true ; done
}

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

## Kubectl Proxy ##
function kubeprox {
  echo "usage: kubeprox namespace service_name port-name(http)"
  if [ $# -eq 0 ]; then
    return
  fi
  open https://localhost:8001/api/v1/namespaces/${1}/services/${2}:${3}/proxy/
  echo "close: ctrl + c"
  kubectl proxy
}

export do="\-o=yaml --dry-run=client"

##### Kubectl Context Autocomplete #####
function kcomp {
echo "krc: get current context"
echo "klc: list all contexts"
echo "kcc: change contexts"
echo "krn: get current namespace"
echo "kln: list namespaces"
echo "kcn: change namespace"
}

alias k=kubectl

alias krc='kubectl config current-context' # Get current context
alias klc='kubectl config get-contexts -o name | sed "s/^/  /;\|^  $(krc)$|s/ /*/"' # List all contexts
alias kcc='kubectl config use-context "$(klc | fzf -e | sed "s/^..//")"' # Change current context
alias krn='kubectl config get-contexts --no-headers "$(krc)" | awk "{print \$5}" | sed "s/^$/default/"' # Get current namespace
alias kln='kubectl get -o name ns | sed "s|^.*/|  |;\|^  $(krn)$|s/ /*/"' # List all namespaces
alias kcn='kubectl config set-context --current --namespace "$(kln | fzf -e | sed "s/^..//")"' # Change current namespace

#### Hosts File Context Autocomplete #####
function hcomp {
echo "hrc: get current hosts context"
echo "hlc: list all hosts contexts"
echo "hcc: change contexts"
echo "hec: edit host file"
echo "hreload: reload dns"
}

alias hrc='find /etc/hosts-custom -inum $(ls -i /etc/hosts | awk '\''{print $1}'\'') -exec ls -i {} \;'
alias hlc='ls -1 /etc/hosts-custom/'
alias hcc='sudo rm -f /etc/hosts && sudo ln /etc/hosts-custom/$(ls -hF /etc/hosts-custom/ | grep -v "/$" | fzf -e) /etc/hosts'
alias hec='sudo vi /etc/hosts-custom/$(ls /etc/hosts-custom/ | fzf -e)'

########### zsh completion for kubectl ###########
autoload -Uz compinit; compinit
source <(kubectl completion zsh)

# The next line updates PATH for the Google Cloud SDK.
if [ -f '$HOME/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '$HOME/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '$HOME/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '$HOME/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
export JSII_SILENCE_WARNING_UNTESTED_NODE_VERSION=true
