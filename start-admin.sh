#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"
read -r -p 'Admin email (use a new email for first setup): ' ADMIN_EMAIL
read -r -s -p 'Admin password (at least 12 characters): ' ADMIN_PASSWORD
printf '\n'
export ADMIN_EMAIL ADMIN_PASSWORD
if [[ "$(uname)" == Darwin ]]; then
  "$(/usr/libexec/java_home -v 17)/bin/java" SmartMobility.java
else
  java SmartMobility.java
fi
