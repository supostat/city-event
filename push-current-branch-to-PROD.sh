#!/bin/sh
#Pushes the branch we are on to the Heroku PRODUCTION site
branch=`git branch|grep \*|awk '{print $2}'`
git push -ff --recurse-submodules=check --progress "prod" refs/heads/$branch:refs/heads/master