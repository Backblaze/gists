API_URL=''; # Provided by b2_authorize_account
ACCOUNT_AUTHORIZATION_TOKEN=''; # Provided by b2_authorize_account
ADMIN_ACCOUNT_ID=''; # Provided b2_authorize_account
GROUP_ID=''; # Provided by b2_list_groups
MEMBER_EMAIL='new-group-member@mycompany.com'; # Email address for account being created
curl \
    -H "Authorization: $ACCOUNT_AUTHORIZATION_TOKEN" \
    -d "`printf '{"adminAccountId":"%s", "groupId": "%s", "memberEmail": "%s"}' $ADMIN_ACCOUNT_ID $GROUP_ID $MEMBER_EMAIL`" \
    "$API_URL/b2api/v4/b2_create_group_member";
