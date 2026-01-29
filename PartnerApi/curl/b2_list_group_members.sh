API_URL=''; # Provided by b2_authorize_account
ACCOUNT_AUTHORIZATION_TOKEN=''; # Provided by b2_authorize_account
ADMIN_ACCOUNT_ID=''; # Provided by b2_authorize_account
GROUP_ID=''; # Provided by b2_list_groups
curl \
    -H "Authorization: $ACCOUNT_AUTHORIZATION_TOKEN" \
    -d "`printf '{"adminAccountId":"%s", "groupId": "%s"}' $ADMIN_ACCOUNT_ID $GROUP_ID`" \
    "$API_URL/b2api/v4/b2_list_group_members";
