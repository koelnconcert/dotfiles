command -v git >/dev/null 2>&1 || { echo >&2 "git it not installed.  Aborting."; exit 1; }
castles=$HOME/.homesick/repos
git clone git://github.com/andsens/homeshick.git $castles/homeshick
source $HOME/.homesick/repos/homeshick/homeshick.sh
homeshick clone -b git://github.com/koelnconcert/dotfiles.git
homeshick link

if [[ `git version`  =~ git\ version\ 1\..* ]]; then
  echo "Old git version found; remove push.default config"
  git config -f ~/.gitconfig --unset push.default
fi



