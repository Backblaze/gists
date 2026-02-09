<?php

$master_application_key_id = ''; // From your B2 account page
$master_application_key = ''; // From your B2 account page

$ch = curl_init('https://api.backblazeb2.com/b2api/v4/b2_authorize_account');
curl_setopt_array($ch, [
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_HTTPHEADER     => [
        'Authorization: Basic ' . base64_encode("$master_application_key_id:$master_application_key"),
    ],
]);

echo curl_exec($ch), PHP_EOL;
