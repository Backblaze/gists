package com.backblaze.examples;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

public class B2UpdateBucket {
    public static void main(String[] args) {
        String apiUrl = ""; // Provided by b2_authorize_account
        String accountAuthorizationToken = ""; // Provided by b2_authorize_account
        String accountId = ""; // Provided by b2_authorize_account
        String bucketId = ""; // The ID of the bucket you want to update
        String bucketType = ""; // The type of bucket: "allPublic" or "allPrivate"

        String postParams = "{" +
                "\"accountId\":\"" + accountId + "\"," +
                "\"bucketId\":\"" + bucketId + "\"," +
                "\"bucketType\":\"" + bucketType + "\"" +
                "}";

        try (HttpClient client = HttpClient.newHttpClient()) {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(apiUrl + "/b2api/v4/b2_update_bucket"))
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
