#!/bin/bash
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin/"

while getopts a:b:c:d:e:f:g:h:i:j:k: option
do	case "$option" in
     a) subscriptionID=$OPTARG;;
     b) applicationProtocols=$OPTARG;;
     c) applicationAddress=$OPTARG;;
     d) applicationServiceFqdn=$OPTARG;;
     e) applicationPort=$OPTARG;;
     f) applicationSecurePort=$OPTARG;;
     g) sslCert=$OPTARG;;
     h) sslPswd=$OPTARG;;
     i) applicationType=$OPTARG;;
     j) blockingLevel=$OPTARG;;
     k) customPolicy=$OPTARG;;
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
