package com.backblaze.examples;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

public class B2StartLargeFile {
    public static void main(String[] args) {
        String apiUrl = ""; // Provided by b2_authorize_account
        String accountAuthorizationToken = ""; // Provided by b2_authorize_account
        String bucketId = ""; // The ID of the destination bucket. The bucket ID is provided by b2_create_bucket, b2_list_buckets.
        String fileName = ""; // Name of the file as it will appear in B2
        String contentType = ""; // Content type of the file

        String postParams = "{" +
                "\"bucketId\":\"" + bucketId + "\"," +
                "\"fileName\":\"" + fileName + "\"," +
                "\"contentType\":\"" + contentType + "\"" +
                "}";

        try (HttpClient client = HttpClient.newHttpClient()) {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(apiUrl + "/b2api/v4/b2_start_large_file"))
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
