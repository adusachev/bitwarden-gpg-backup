#!/bin/bash


GPG_EMAIL=your_gpg_email@gmail.com
BW_EMAIL=your_bitwarden_email@gmail.com

read -p "Bitwarden Master Password (hidden): " -s BW_PASS
export BW_SESSION=$(bw login $BW_EMAIL $BW_PASS --raw)

EXPORT_FILE_PREFIX="bw_export_"
TIMESTAMP=$(date "+%Y_%m_%d_%H%M%S")
ENC_OUTPUT_FILE=$EXPORT_FILE_PREFIX$TIMESTAMP.enc

bw export --raw --session $BW_SESSION --format json | gpg -o $ENC_OUTPUT_FILE -e -a -r $GPG_EMAIL

bw logout > /dev/null
unset BW_SESSION
unset BW_PASS
unset BW_ACCOUNT

echo -e "\n\nSuccessful vault backup to file $(realpath $ENC_OUTPUT_FILE) \n"
