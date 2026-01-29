<?php

$api_url = ''; // Provided by b2_authorize_account
$auth_token = ''; // Provided by b2_authorize_account
$admin_account_id = ''; // Provided by b2_authorize_account
$group_id = ''; // Provided by b2_list_groups
$member_account_id = ''; // Provided by b2_create_group_member or b2_list_group_members

$postData = json_encode([
    'adminAccountId' => $admin_account_id,
    'groupId' => $group_id,
    'memberAccountId' => $member_account_id,
]);

$ch = curl_init($api_url . '/b2api/v4/b2_eject_group_member');
curl_setopt_array($ch, [
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_POST           => true,
    CURLOPT_HTTPHEADER     => [
        "Authorization: $auth_token",
        'Content-Type: application/json',
    ],
    CURLOPT_POSTFIELDS     => $postData,
]);

echo curl_exec($ch), PHP_EOL;
