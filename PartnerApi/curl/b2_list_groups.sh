API_URL=''; # Provided by b2_authorize_account
ACCOUNT_AUTHORIZATION_TOKEN=''; # Provided by b2_authorize_account
ADMIN_ACCOUNT_ID=''; # Provided by b2_authorize_account
curl \
    -H "Authorization: $ACCOUNT_AUTHORIZATION_TOKEN" \
    -d "`printf '{"adminAccountId":"%s"}' $ADMIN_ACCOUNT_ID`" \
    "$API_URL/b2api/v4/b2_list_groups";
