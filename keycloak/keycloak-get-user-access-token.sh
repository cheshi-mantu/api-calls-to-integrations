USERNAME=$(cat ../secrets/kc_username.txt)
U_PASSWORD=$(cat ../secrets/kc_user_password.txt)
CLIENT_ID=$(cat ../secrets/kc_client.txt)
KC_URL=$(cat ../secrets/kc_url.txt)
KC_REALM=$(cat ../secrets/kc_realm.txt)

RESPONSE=$(curl -X POST "http://${KC_URL}/realms/${KC_REALM}/protocol/openid-connect/token" \
    --data-urlencode "client_id=${CLIENT_ID}" \
    --data-urlencode 'grant_type=password' \
    --data-urlencode 'scope=openid' \
    --data-urlencode "username=${USERNAME}" \
    --data-urlencode "password=${U_PASSWORD}")
    # --data-urlencode 'client_secret=not using' \

ACCESS_TOKEN=$(echo $RESPONSE | jq .access_token)
BARE_JWT=$(echo "$ACCESS_TOKEN" | sed 's/^"\(.*\)"$/\1/')
echo $BARE_JWT | jq -R 'split(".") | .[0],.[1] | @base64d | fromjson'
