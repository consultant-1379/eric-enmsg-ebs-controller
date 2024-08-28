#!/bin/bash
APPS_ID="countermanagement"
APPS_PATH=/ericsson/tor/data/apps
HTML_PATH=/var/www/html
_RSYNC=/usr/bin/rsync
mkdir -m 775 -p $APPS_PATH/$APPS_ID/locales/en-us
$_RSYNC -avz --perms --chmod=D775,F664 --no-times --no-perms --no-group $HTML_PATH/$APPS_ID/metadata/countermanagement/countermanagement.json $APPS_PATH/$APPS_ID/
$_RSYNC -avz --perms --chmod=D775,F664 --no-times --no-perms --no-group $HTML_PATH/locales/en-us/$APPS_ID/* $APPS_PATH/$APPS_ID/locales/en-us