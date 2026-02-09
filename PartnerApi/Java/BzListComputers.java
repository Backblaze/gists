package com.backblaze.examples;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

public class BzListComputers {
    public static void main(String[] args) {
        String apiUrl = ""; // Provided by b2_authorize_account
        String accountAuthorizationToken = ""; // Provided by b2_authorize_account
        String accountId = ""; // Provided by b2_list_group_members

        String postParams = "{\"accountId\":\"" + accountId + "\"}";
        try (HttpClient client = HttpClient.newHttpClient()) {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(apiUrl + "/api/backup/v1/bz_list_computers"))
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
