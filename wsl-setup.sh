#!/bin/bash

# ============================================================
# Please change the values below for your environment.
# ============================================================

ENV_APT_REPOSITORY='http://mirror.kakao.com/ubuntu/'
ENV_GIT_NAME='retn0'
ENV_GIT_EMAIL='nbsp1221@gmail.com'

# ============================================================
# Please change the values above for your environment.
# ============================================================

error() {
  printf '\033[1;31mError:\033[0m %s\n' "$1"
}

env() {
  printf '\033[1;34m%s:\033[0m %s\n' "$1" "$2"
}

tasks() {
  # Change APT repository
  sudo sed -i "s+$(awk '$1 == "deb" { print $2 }' /etc/apt/sources.list | head -1)+${ENV_APT_REPOSITORY}+g" /etc/apt/sources.list

  # Update APT
  sudo apt update

  # Upgrade APT
  sudo apt upgrade -y

  # Install `screenfetch`, `net-tools`, `gcc`, `g++`
  sudo apt install -y screenfetch net-tools gcc g++

  # Install `Node.js`
  curl -sL https://deb.nodesource.com/setup_current.x | sudo -E bash -
  sudo apt install -y nodejs

  # Install `Zsh` and `Oh My Zsh`
  export RUNZSH='no'
  sudo apt install -y zsh
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  # Set `agnoster` theme for `Zsh`
  sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/g' ~/.zshrc
  cat "$(pwd)/settings/zshrc-settings" >> ~/.zshrc

  # Install plugins for `Zsh`
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

  # Set plugins for `Zsh`
  sed -i 's/plugins=(git)/plugins=(git npm zsh-autosuggestions zsh-syntax-highlighting)/g' ~/.zshrc

  # Configuare `git`
  git config --global user.name "${ENV_GIT_NAME}"
  git config --global user.email ${ENV_GIT_EMAIL}
  git config --global core.editor "code --wait"
}

if [[ $(id | awk '{print $1}') == 'uid=0(root)' ]]; then
  error 'Do not run this script as root.'
  exit
fi

echo ''
echo '                __                __            '
echo ' _      _______/ /     ________  / /___  ______ '
echo '| | /| / / ___/ /_____/ ___/ _ \/ __/ / / / __ \'
echo '| |/ |/ (__  ) /_____(__  )  __/ /_/ /_/ / /_/ /'
echo '|__/|__/____/_/     /____/\___/\__/\__,_/ .___/ '
echo '                                       /_/      '
echo ''
printf '\033[1;37mCopyright 2020 nbsp1221\033[0m\n'
printf '\033[1;37mMIT License\033[0m\n'
printf '\033[1;37mhttps://github.com/nbsp1221/wsl-setup\033[0m\n'
echo ''
env 'ENV_APT_REPOSITORY' "${ENV_APT_REPOSITORY}"
env 'ENV_GIT_NAME' "${ENV_GIT_NAME}"
env 'ENV_GIT_EMAIL' "${ENV_GIT_EMAIL}"
echo ''
printf '\033[1;33mPlease check the environment values above.\033[0m\n'
printf 'Do you want to continue? [y/n] '
read yn

if [[ "$yn" != 'y' && "$yn" != 'Y' ]]; then
  echo 'Aborted.'
  exit
fi

tasks
clear
screenfetch

echo ''
printf '\033[1;32mWSL setup is completed.\033[0m\n'
echo 'Please restart your shell.'
echo ''
