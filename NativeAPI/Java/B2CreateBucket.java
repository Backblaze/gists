package com.backblaze.examples;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

public class B2CreateBucket {
    public static void main(String[] args) {
        String apiUrl = ""; // Provided by b2_authorize_account
        String accountAuthorizationToken = "";  // Provided by b2_authorize_account
        String accountId = ""; // Provided by b2_authorize_account
        String bucketName = ""; // Name of the bucket you want to create
        String bucketType = ""; // Either "allPublic" or "allPrivate"

        String postParams = "{" +
                "\"accountId\":\"" + accountId + "\"," +
                "\"bucketName\":\"" + bucketName + "\"," +
                "\"bucketType\":\"" + bucketType + "\"" +
                "}";

        try (HttpClient client = HttpClient.newHttpClient()) {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(apiUrl + "/b2api/v4/b2_create_bucket"))
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
