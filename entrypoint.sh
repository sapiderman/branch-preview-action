#!/bin/bash

echo "Starting action"

eval $(ssh-agent -s)

echo "Setting up SSH"
mkdir -p ~/.ssh
chmod 700 ~/.ssh
echo -e "$DOKKU_KEY" > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa
ssh-keyscan "$HOST" >> ~/.ssh/known_hosts

cd "$GITHUB_WORKSPACE"

CURRENT_BRANCH=`git rev-parse --abbrev-ref HEAD`

if [[ -v $SUBDOMAIN ]]; then

  APP_NAME=$SUBDOMAIN
else
  APP_NAME=${CURRENT_BRANCH/\//-}
fi

echo " *** info *********************** "
echo " current_branch is: $CURRENT_BRANCH "
echo " usdomain input is: $SUBDOMAIN "
echo " so applicaiton is: $APP_NAME "
echo " ********************************** "


echo "Checking if app exists"
ssh "dokku@$HOST" -p $PORT dokku apps:exists $APP_NAME

if [[ $? != 0 ]]; then
  echo "*** The app does not exist yet, creating the app: $APP_NAME ***"
  ssh "dokku@$HOST" -p $PORT dokku apps:create $APP_NAME
fi

echo "*** Deploying to host *** "
git fetch --unshallow
git remote add $APP_NAME "dokku@$HOST:$APP_NAME"
echo "*** pushing changes to app:$APP_NAME ***"
git push -f $APP_NAME "$CURRENT_BRANCH:master"
echo "*** done... thank you. ***"


