#!/bin/bash
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin/"

while getopts i:p:e:d:a:f:c:w:x: option
do	case "$option" in
     i) InstanceID=$OPTARG;;
     p) CustSubID=$OPTARG;;
     e) CustIPEndPt=$OPTARG;;
     d) ServLevel=$OPTARG;;
     a) Status=$OPTARG;;
     f) AppType=$OPTARG;;
     c) Protocol=$OPTARG;;
     Z) sslCert=$OPTARG;;
     w) sslPswd=$OPTARG;;
    esac 
done

user="admin"

# download and install Certificate
echo "Starting Certificate download"
certificate_location=$sslCert
response_code=$(curl -k -s -f --retry 5 --retry-delay 10 --retry-max-time 10 -o /var/tenantcert.pfx $certificate_location)

if [[ $response_code != 200  ]]; then
     echo "Failed to download certificate with response code '"$response_code"'"
     exit
else 
     echo "Certificate download complete."
fi

# Make webhook call to Onboarding processor

     response_code=$(curl -sku $user:$(passwd) -w "%{http_code}" -X POST -H "Content-Type: application/json" https://localhost/mgmt/tm/sys/config -d '{"command": "load","name": "merge","options": [ { "file": "/config/'"$template"'" } ] }' -o /dev/null)
     if [[ $response_code != 200  ]]; then
          echo "Failed to post to Onboarding system with response code '"$response_code"'"
          exit
     else
          echo "Onboarding webhook call made."
     fi
     sleep 10
done

# destroy webhook url
exit
