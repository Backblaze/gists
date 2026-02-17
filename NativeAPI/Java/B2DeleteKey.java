package com.backblaze.examples;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

public class B2DeleteKey {
    public static void main(String[] args) {
        String apiUrl = ""; // Provided by b2_authorize_account
        String accountAuthorizationToken = ""; // Provided by b2_authorize_account
        String applicationKeyId = ""; // ID of the key you want to delete

        String postParams = "{" +
                "\"applicationKeyId\":\"" + applicationKeyId + "\"" +
                "}";
        try (HttpClient client = HttpClient.newHttpClient()) {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(apiUrl + "/b2api/v4/b2_delete_key"))
                    .header("Authorization", accountAuthorizationToken)
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
