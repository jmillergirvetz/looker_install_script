#!/bin/bash
​
# Fill in your license key and email on line 7
​
cd /home/looker/looker
./looker stop
curl -s -i -X POST -H 'Content-Type:application/json' -d '{"lic": "", "email": "", "latest":"latest"}' https://apidownload.looker.com/download -o /home/looker/looker/response.txt
sed -i 1,9d /home/looker/looker/response.txt
eula=$(cat /home/looker/looker/response.txt | jq -r '.eulaMessage')
if [[ "$eula" =~ .*EULA.* ]]; then echo "Error! This script was unable to download the latest Looker JAR file because you have not accepted the EULA. Please go to https://download.looker.com/validate and fill in the form."; fi;
url=$(cat /home/looker/looker/response.txt | jq -r '.url')
curl $url -o /home/looker/looker/looker.jar
url=$(cat /home/looker/looker/response.txt | jq -r '.depUrl')
curl $url -o /home/looker/looker/looker-dependencies.jar
rm /home/looker/looker/response.txt
./looker start
