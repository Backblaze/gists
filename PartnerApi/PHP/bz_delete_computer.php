<?php

$api_url = ''; // Provided by b2_authorize_account
$auth_token = ''; // Provided by b2_authorize_account
$account_id = ''; // Provided by b2_list_group_members
$computer_id = ''; // Provided by bz_list_computers

$postData = json_encode([
    'accountId' => $account_id,
    'computerId' => $computer_id,
]);

$ch = curl_init($api_url . '/api/backup/v1/bz_delete_computer');
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
