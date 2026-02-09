API_URL=''; # Provided by b2_authorize_account
ACCOUNT_AUTHORIZATION_TOKEN=''; # Provided by b2_authorize_account
MEMBER_EMAIL='new-b2-reserve-member@mycompany.com'; # Email address for member being created
TERM_IN_DAYS='7'; # Length of trial period in days
STORAGE_IN_TB='1'; # Amount of storage in TB
curl \
    -H "Authorization: $ACCOUNT_AUTHORIZATION_TOKEN" \
    -d "`printf '{"email": "%s", "term": %d, "storage": %d}' $ADMIN_ACCOUNT_ID $GROUP_ID $MEMBER_EMAIL $TERM_IN_DAYS $STORAGE_IN_TB`" \
    "$API_URL/b2api/v4/b2_reserve_trial_create_account";
