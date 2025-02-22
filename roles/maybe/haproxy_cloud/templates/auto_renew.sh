#!/bin/bash

# - Congratulations! Your certificate and chain have been saved at:
#   /etc/letsencrypt/live/habbfarm.net/fullchain.pem
#   Your key file has been saved at:
#   /etc/letsencrypt/live/habbfarm.net/privkey.pem

service nginx stop

service haproxy stop


# add new domain name here
for i in nextcloud testnextcloud git;
do
        #certbot --expand --authenticator standalone certonly -d $i.habbfarm.net  -d habbfarm.net
        # delete global fullcert to get a clean file
        rm -f /etc/letsencrypt/live/habbfarm.net/fullcert.pem
        cat /etc/letsencrypt/live/$i.habbfarm.net/fullchain.pem /etc/letsencrypt/live/$i.habbfarm.net/privkey.pem  >> /etc/letsencrypt/live/habbfarm.net/fullcert.pem
done
#certbot --expand --authenticator standalone certonly -d testnextcloud.habbfarm.net -d nextcloud.habbfarm.net -d habbfarm.net -d git.habbfarm.net --dry-run

# didn't work?
# --pre-hook "service nginx stop && service haproxy stop" --post-hook "service nginx start && service haproxy start"

sleep 2


#Let's Encrypt Needs the cert *and* the key in one file. This cat command will fix you up. Be sure the paths match what you've set in your HAProxy conifg
cat /etc/letsencrypt/live/habbfarm.net/fullchain.pem /etc/letsencrypt/live/habbfarm.net/privkey.pem >> /etc/letsencrypt/live/habbfarm.net/fullcert.pem

sleep 2

service nginx start
service haproxy start
