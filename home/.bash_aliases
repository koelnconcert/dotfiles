alias ll='ls -l'
alias l='ls -al'
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias o='less -S'
alias m='more'
alias h='history'
alias j="jobs -l"

show_aliases_for() {
  alias | grep $@ | sed "s/^alias //" | sed "s/^\([^=]*\)=\(.*\)/\1\t\2/"| sed "s/['|\']//g" |sort
}

#git
alias gci='git commit'
alias gst='git status --untracked-files=no --short'
alias gsta='git status --short'
alias gstr='find -type d -name .git -printf "==> %h\n" -execdir git status --short --untracked-files=no \;'
alias gstra='find -type d -name .git -printf "==> %h\n" -execdir git status --short \;'
alias gls='git ls-files --directory'
alias gco='git checkout'
alias gbr='git branch'
alias gd='git diff'
alias gds='git diff --staged'
alias ga='git add'
alias gai='git add -i'
alias gf='git fetch'
alias gfa='git fetch --all'
git_log_format='format:%C(auto)%h %Cblue%ad%Creset%C(auto)%d %Cgreen%an%Creset %s'
alias gl="git log --graph --date-order --pretty='$git_log_format'"
alias glv='git log --graph --date-order'
alias gla="git log --graph --date-order --pretty='$git_log_format' --all"
alias glav='git log --graph --date-order --all'
alias gff='git merge --ff-only'
alias galias='show_aliases_for git'
alias gcd='cd `git root`'

#docker
alias dps="docker ps"
alias di="docker images"
dbu() { docker build -t=$1 .;}
alias dalias='show_aliases_for docker'
alias dicl='docker rmi $(docker images --no-trunc | grep "^<none>" | awk "{print \$3}")'

alias df='df -h'

alias curl_json='curl -H "Accept: application/json"'

alias acp='apt-cache policy'
alias acs='apt-cache search'

alias ack='ack-grep'

alias column-tab="column -s $'\t'"

alias ncdu='ncdu --exclude .snapshots'
