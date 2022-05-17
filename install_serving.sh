#!/usr/bin/env bash

set -eo pipefail

echo -e "✅ Checking dependencies... \033[0m"
STARTTIME=$(date +%s)

# The command below executes 01-kind.sh in the same bash shell so that exit commands are not swallowed
source 01-kind.sh
echo -e "🍿 Installing Knative Serving... \033[0m"
bash 02-serving.sh
echo -e "🔌 Installing Knative Serving Networking Layer kourier... \033[0m"
bash 02-kourier.sh

# Setup Knative DOMAIN DNS
INGRESS_HOST="127.0.0.1"
KNATIVE_DOMAIN=$INGRESS_HOST.sslip.io
kubectl patch configmap -n knative-serving config-domain -p "{\"data\": {\"$KNATIVE_DOMAIN\": \"\"}}"

DURATION=$(($(date +%s) - $STARTTIME))
echo -e "\033[0;92m 🚀 Knative install took: $(($DURATION / 60))m$(($DURATION % 60))s \033[0m"
echo -e "\033[0;92m 🎉 Now have some fun with Serverless and Event Driven Apps \033[0m"
