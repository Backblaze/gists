<?php

$api_url = ''; // Provided by b2_authorize_account
$auth_token = ''; // Provided by b2_authorize_account
$member_email = 'new-b2-reserve-member@mycompany.com'; // Email address for account being created
$term_in_days = 7; // Length of trial period in days
$storage_in_tb = 10; // Amount of storage in TB

$postData = json_encode([
    'email' => $member_email,
    'term' => $term_in_days,
    'storage' => $storage_in_tb,
]);

$ch = curl_init($api_url . '/b2api/v4/b2_reserve_trial_create_account');
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
