API_URL=''; # Provided by b2_authorize_account
ACCOUNT_AUTHORIZATION_TOKEN=''; # Provided by b2_authorize_account
ADMIN_ACCOUNT_ID=''; # Provided by b2_authorize_account
GROUP_ID=''; # Provided by b2_list_groups
MEMBER_ACCOUNT_ID=''; # Provided by b2_create_group_member or b2_list_group_members
curl \
    -H "Authorization: $ACCOUNT_AUTHORIZATION_TOKEN" \
    -d "`printf '{"adminAccountId":"%s", "groupId": "%s", "memberAccountId": "%s"}' $ADMIN_ACCOUNT_ID $GROUP_ID $MEMBER_ACCOUNT_ID`" \
    "$API_URL/b2api/v4/b2_eject_group_member";
