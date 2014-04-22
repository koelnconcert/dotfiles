alias ll='ls -l'
alias l='ls -al'
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias o='less -S'
alias m='more'
alias h='history'
alias j="jobs -l"

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
git_log_format='format:%H%Cred%d%Creset %Cblue%ai%Creset %Cgreen%an%Creset %s'
alias gl="git log --graph --date-order --pretty='$git_log_format'"
alias glv='git log --graph --date-order'
alias gla="git log --graph --date-order --pretty='$git_log_format' --all"
alias glav='git log --graph --date-order --all'

alias df='df -h'

alias curl_json='curl -H "Accept: application/json"'

alias acp='apt-cache policy'
alias acs='apt-cache search'
