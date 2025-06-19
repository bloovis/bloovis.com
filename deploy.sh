#!/bin/sh
# This script updates the web site from the local copy.
# Use the --delete parameter to purge extraneous files from the web site.
#hugo && rsync -av "$@" public bloovis_bloovis@ssh.phx.nearlyfreespeech.net:/home
hugo && rsync -av "$@" public/ marka@bionic.bloovis.com:/var/www/html
