API_URL=''; # Provided by b2_authorize_account
ACCOUNT_AUTHORIZATION_TOKEN=''; # Provided by b2_authorize_account
ACCOUNT_ID=''; # Provided by b2_list_group_members
COMPUTER_ID=''; # Provided by bz_list_computers
curl \
    -H "Authorization: $ACCOUNT_AUTHORIZATION_TOKEN" \
    -d "`printf '{"accountId":"%s", "computerId": "%s"}' $ACCOUNT_ID $COMPUTER_ID`" \
    "$API_URL/api/backup/v1/bz_delete_computer";
