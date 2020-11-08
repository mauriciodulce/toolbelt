#!/bin/bash

CASK_APPLICATIONS=(
    "dropbox"
    "firefox"
    "iterm2"
    "lando"
    "keepingyouawake"
    "sequel-pro"
    "spectacle"
    "sketch"
    "slack"
    "spotify"
    "sublime-merge"
    "sublime-text"
    "transmit"
    "visual-studio-code"
    "webstorm"
)

OPEN_APPLICATIONS=(
    "iTerm"
    "KeepingYouAwake"
    "PhpStorm"
    "Sequel Pro"
    "Spectacle"
)

main () {
    clear

    ascii

    if [ "$(uname)" == "Darwin" ]; then
        echo "$(uname) detected..."
    else
        exit 1
    fi

    xcode-select --install



    # Install Homebrew
    installHomebrew

    # Brew some software
    brew install ansible

    # Install gems
    gem install pygmy

    # Install node
    brew install yarn
    npm install gulp-cli -g
    npm install -g yo
    npm install -g bower

    # Install Composer and Drush
    installPhpTools

    # Install applications
    installApplications

    # Install oh my zsh
    if [[ $TRAVIS ]]; then
        echo "Skipping Oh My Zsh installation in Travis."
     else
        installOhMy
    fi

    # Open applications for the first time so user can login, register, setup etc.
    openApplications

    exit 0
}

ascii () {
cat << "EOF"

 __  __                  _      _       ____        _
|  \/  | __ _ _   _ _ __(_) ___(_) ___ |  _ \ _   _| | ___ ___
| |\/| |/ _` | | | | '__| |/ __| |/ _ \| | | | | | | |/ __/ _ \
| |  | | (_| | |_| | |  | | (__| | (_) | |_| | |_| | | (_|  __/
|_|  |_|\__,_|\__,_|_|  |_|\___|_|\___/|____/ \__,_|_|\___\___| 
 _              _ _          _ _
| |_ ___   ___ | | |__   ___| | |_
| __/ _ \ / _ \| | '_ \ / _ \ | __|
| || (_) | (_) | | |_) |  __/ | |_
 \__\___/ \___/|_|_.__/ \___|_|\__|
EOF
}

installApplications () {
    # Install Casks
    printSectionTitle "Install applications"
    cmd="brew cask install ${CASK_APPLICATIONS[*]}"
    $cmd


    git config --global user.name "Mauricio Dulce"
    git config --global user.email "hola@mauriciodulce.com"
}

installHomebrew () {
    printSectionTitle "Install Homebrew"

    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew doctor
}

installOhMy () {
    printSectionTitle "Install oh my zsh"

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    
}

installPhpTools () {
    printSectionTitle "PHP tools"

    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php composer-setup.php
    php -r "unlink('composer-setup.php');"
    chmod +x composer.phar
    mv composer.phar /usr/local/bin/composer

    curl -O -L https://github.com/drush-ops/drush/releases/download/8.1.16/drush.phar
    chmod +x drush.phar
    mv drush.phar /usr/local/bin/drush

    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
    
    curl -sS https://platform.sh/cli/installer | php


}

openApplications () {
    printSectionTitle "Opening applications for the first time"

    # Open applications
    for app in "${OPEN_APPLICATIONS[@]}"
    do
       osascript -e "tell application \"$app\" to activate"
    done
}

printSectionTitle () {
    printf "\n\n--- %s ---\n\n" "$1"
}

promptYesNo () {
    while true; do
        read -p "$1 (y/n): " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

main
