#!/bin/sh
#Pushes the branch we are on to the Heroku dev site
branch=`git branch|grep \*|awk '{print $2}'`
git push -ff --recurse-submodules=check --progress "heroku-dev" refs/heads/$branch:refs/heads/master
#heroku run rake db:migrate --app event-registration-dev
heroku logs -t --app event-registration-dev