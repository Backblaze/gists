package com.backblaze.examples;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

public class B2ReserveTrialCreateAccount {
    public static void main(String[] args) {
        String apiUrl = ""; // Provided by b2_authorize_account
        String accountAuthorizationToken = ""; // Provided by b2_authorize_account
        String memberEmail = "new-b2-reserve-member@mycompany.com"; // Email address for member being created
        String termInDays = "7"; // Length of trial period in days
        String storageInTb = "10"; // Amount of storage in TB

        String postParams = "{\"email\":\"" + memberEmail + "\",\"term\":" + termInDays + ",\"storage\":" + storageInTb + "}";
        try (HttpClient client = HttpClient.newHttpClient()) {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(apiUrl + "/b2api/v4/b2_reserve_trial_create_account"))
                    .header("Authorization", accountAuthorizationToken)
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(postParams))
                    .build();
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
            String jsonResponse = response.body();
            System.out.println(jsonResponse);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
