#!/usr/bin/env bash

declare -r HOMEBREW_LINK="https://raw.githubusercontent.com/Homebrew/install/master/install"
declare -r LINUXBREW_LINK="https://raw.githubusercontent.com/Linuxbrew/install/master/install"

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install Homebrew (if not installed)
if [[ ! $(command -v brew) ]]; then
    echo "Installing Homebrew..."

    # Install the correct Homebrew for each OS type
    if [[ "$(uname)" = "Darwin" ]]
    then
        ruby -e "$(curl -fsSL ${HOMEBREW_LINK})"
    elif [[ "$(uname -s)" = "Linux" ]]; then
        ruby -e "$(curl -fsSL ${LINUXBREW_LINK})"
    else
        echo "Cannot install Homebrew on an unsupported operating system."
        exit 1
    fi
fi

# Update Homebrew
brew update

# Upgrade already-installed software
brew upgrade

# Save Homebrew’s directory location
BREW_PREFIX=$(brew --prefix)

# Install GNU core utilities
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Install some other useful utilities like `sponge`
brew install moreutils

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed
brew install findutils

# Install GNU `sed`, overwriting the built-in `sed`
brew install gnu-sed

# Install the latest bash
brew install bash
brew install bash-completion@2

echo "Adding the newly installed shell to the list of allowed shells"
# Prompts for password
sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells'
# Change to the new shell, prompts for password
chsh -s /usr/local/bin/bash

# Install JDK
brew install openjdk@11
sudo ln -sfn $(brew --prefix)/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk

# Install misc

brew install maven
brew install maven-completion
brew install maven-shell
brew install bazelisk
brew install docker-credential-helper
brew install gmp
brew install grep
brew install node
brew install git
brew install git-lfs
brew install htop
brew install ack
brew install autojump
brew install jenv
brew install jq
brew install mtr
brew install mysql
brew install mysql-client
brew install ncdu
brew install python
brew install python@2
brew install pygments
brew install redis
brew install rsync
brew install rename
brew install trash
brew install tree
brew install screen
brew install ssh-copy-id
brew install vim
brew install wget
brew install yarn
brew install yarn-completion
brew install z

# Add repositories
brew cask
brew services

# Install cask applications
brew cask install alfred
brew cask install beamer
brew cask install dash
brew cask install drawio
brew cask install virtualbox
brew cask install docker
brew cask install docker-toolbox
brew cask install flux
brew cask install iterm2
brew cask install gimp
brew cask install google-chrome
brew cask install google-cloud-sdk
brew cask install firefox
brew cask install grammarly
brew cask install jetbrains-toolbox
brew cask install kap
brew cask install messenger
brew cask install ngrok
brew cask install postman
brew cask install slack
brew cask install sourcetree
brew cask install spectacle
brew cask install spotify
brew cask install sublime-text
brew cask install tunnelblick
brew cask install vlc
brew cask install whatsapp
brew cask install zoomus

# Remove outdated versions from the cellar
brew cleanup
