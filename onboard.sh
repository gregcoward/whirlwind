#!/bin/bash
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin/"

while getopts a:b:c:d:e:f:g:h:i:j:k:l:m: option
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
	 l) adminUserName=$OPTARG;;
     m) adminPassword=$OPTARG;;
	 esac 
done

# download and install Certificate
echo "Starting Certificate download"
certificate_location=$sslCert
curl -k -s -f --retry 5 --retry-delay 10 --retry-max-time 10 -o tenantcert.pfx $certificate_location


# Make webhook call to Onboarding processor

curl --data '{"subscriptionID": "'"$subscriptionID"'" ,"applicationAddress": "'"$applicationAddress"'","blockingLevel": "'"$blockingLevel"'","applicationType": "'"$applicationType"'","applicationProtocols": "'"$applicationProtocols"'", "applicationPort": "'"$applicationPort"'", "applicationSecurePort": "'"$applicationSecurePort"'", "applicationServiceFqdn": "'"$applicationServiceFqdn"'", "customPolicy": "'"$customPolicy"'"}' https://s13events.azure-automation.net/webhooks?token=1fc5iujHUDOQkUc%2b%2bU2yireoqmZdJTdEReIMzm%2bYhOk%3d

# destroy webhook url
exit
