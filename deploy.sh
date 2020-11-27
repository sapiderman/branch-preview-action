#!/bin/bash

echo "Setting up SSH directory"
SSH_PATH="$HOME/.ssh"
mkdir -p "$SSH_PATH"
chmod 700 "$SSH_PATH"

echo "Saving SSH key"
echo "$PRIVATE_KEY" > "$SSH_PATH/deploy_key"
chmod 600 "$SSH_PATH/deploy_key"

echo "Registering key to ssh-agent"
eval $(ssh-agent -s)
ssh-add -k "$SSH_PATH/deploy_key"

echo "Adding hosts key to known_hosts"
touch "$SSH_PATH/known_hosts"
chmod 600 "$SSH_PATH/known_hosts"
ssh-keyscan -t rsa "$HOST" >> "$SSH_PATH/known_hosts"

DEFAULT_BRANCH=${DEFAULT_BRANCH:-'master'}
CURRENT_BRANCH=`git rev-parse --abbrev-ref HEAD`

if [[ $CURRENT_BRANCH == $DEFAULT_BRANCH && -n $DOMAIN_NAME ]]; then
  APP_NAME=$DOMAIN_NAME
else
  APP_NAME=${CURRENT_BRANCH/\//-}
fi

echo "Checking if app exists"
ssh "dokku@$HOST" apps:exists $APP_NAME

if [[ $? != 0 ]]; then
  echo "The app does not exist yet, creating the app"
  ssh "dokku@$HOST" apps:create $APP_NAME
fi

echo "Deploying to host"
git fetch --unshallow
git remote add $APP_NAME "dokku@$HOST:$APP_NAME"
git push -f $APP_NAME "$CURRENT_BRANCH:master"