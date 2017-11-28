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
git_log_format='format:%C(auto)%h %Cblue%ad%Creset%C(auto)%d %Cgreen%an%Creset %s'
alias gci='git commit'
alias gst='git status --untracked-files=no --short'
alias gsta='git status --short'
alias gstr='git recursive branch-status | less -S -R'
alias grr='git recursive --label=lines remote-status | grep -v = | column -t'
alias grra='git recursive --label=lines remote-status | column -t'
alias gls='git ls-files --directory'
alias gco='git checkout'
alias gbr='git branch -vv'
alias gd='git diff'
alias gds='git diff --staged'
alias gai='git add -i'
alias gf='git fetch'
alias gfa='git fetch --all'
alias gfr='git recursive fetch --all'
alias gl="git log --graph --date-order --pretty='$git_log_format'"
alias gla="git log --graph --date-order --pretty='$git_log_format' --all"
alias gff='git merge --ff-only'
alias gffr='git recursive merge --ff-only'
alias galias='show_aliases_for git'
alias gcd='cd `git root`'
alias tiga='tig --all'

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

alias column-tab="column -s $'\t'"

alias ncdu='ncdu --exclude .snapshots'

alias agl='ag --pager "less -R"'
agf() { ag -g $@ | ag $1 ; }
agfl() { ag -g $@ | agl $1 ; }
