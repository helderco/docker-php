#!/bin/bash

SMTP_CONF=/etc/ssmtp/ssmtp.conf

# Add default ssmtp config if none exists
if [ ! -f $SMTP_CONF ]; then
    echo -e "mailhub=mail:25\nUseTLS=NO\nFromLineOverride=YES" > $SMTP_CONF
    chown :ssmtp $SMTP_CONF
    chmod 640 $SMTP_CONF
fi
