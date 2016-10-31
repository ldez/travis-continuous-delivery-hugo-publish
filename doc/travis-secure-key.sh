#!/bin/sh
set -e

## Here, you will need to replace <org@email>, <somewhere> and <token>
USER_EMAIL='<org@email>'
PROJECT_DIRECTORY='<somewhere>'
SSH_KEY_NAME='travis_rsa'
GITHUB_TOKEN='<token>'


## Generate SSH key if necessary.
generateKey() {
  if [ ! -e ~/.ssh/travis_rsa ]; then
    ## First you create a RSA public/private key pair just for Travis.
    ssh-keygen -t rsa -C "${USER_EMAIL}" -f ~/.ssh/${SSH_KEY_NAME}
  else
    echo "SSH key ${SSH_KEY_NAME} already exists"
  fi

  ## Copy to clipboard.
  ## https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account
  xclip -sel clip < ~/.ssh/${SSH_KEY_NAME}.pub

  echo 'The public SSH key has been copied into the clipboard.'
  echo 'Go on https://github.com/settings/keys.'
  echo '* Paste your key into the "Key" field.'
  echo '* Click "Add key".'
  echo '* Confirm the action by entering your GitHub password.'
}

## Test if a command exists.
commandExists() {
  command -v "$1" 1>/dev/null 2>&1 && return 0 || return 1
}

## Install Travis CLI if necessary.
installTravis() {
  if commandExists travis
  then
    echo 'Travis CLI already installed.'
  else
    echo 'Install Travis CLI.'

    ## Ruby dev dependencies via RVM (https://rvm.io), needed by Travis CLI
    # rvm install 2.3.0-dev

    ## Install Travis CLI if necessary.
    commandExists travis || sudo gem install travis

    ## Logged in to Travis CI
    travis login --github-token ${GITHUB_TOKEN}
  fi
}

## Encrypt SSH key
## Generate encryption key and store them in secured environment variable in Travis CI.
encryptAndStoreKey() {
  ## Let's go to where your ".travis.yml" is.
  cd ${PROJECT_DIRECTORY}
  mkdir -p .travis

  ## Encrypt SSH key
  ## https://docs.travis-ci.com/user/encrypting-files/
  ## https://github.com/travis-ci/travis.rb#encrypt-file
  travis encrypt-file ~/.ssh/${SSH_KEY_NAME} .travis/${SSH_KEY_NAME}.enc --add
}

#################
## Main Action ##
#################

## Generate SSH key if necessary.
generateKey

## Install Travis CLI if necessary.
installTravis

## Encrypt SSH key and store into ".travis" directory.
encryptAndStoreKey
