#!/bin/sh
perl -pi \
  -e 's/FirstDay%20Cottage/firstday-cottage/;' \
"$@"
