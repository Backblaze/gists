package com.backblaze.examples;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

public class B2CreateKey {
    public static void main(String[] args) {
        String apiUrl = ""; // Provided by b2_authorize_account
        String accountAuthorizationToken = ""; // Provided by b2_authorize_account
        String accountId = ""; // Provided by b2_authorize_account
        String capabilities = ""; // JSON array of key capabilities
        String keyName = ""; // Name for the key
        int validDurationInSeconds = 0; // Validity period, positive integer less than 86,400,000 (optional)
        String bucketId = ""; // Restrict key to this bucket (optional)
        String namePrefix = ""; // Restrict access to files with names starting with this prefix (optional)

        String postParams = "{" +
                "\"accountId\": \"" + accountId + "\"," +
                "\"capabilities\": " + capabilities + "," +
                "\"keyName\": \"" + keyName + "\"," +
                "\"validDurationInSeconds\": " + validDurationInSeconds + "," +
                "\"bucketIds\": [\"" + bucketId + "\"]," +
                "\"namePrefix\": \"" + namePrefix + "\"" +
                "}";

        try (HttpClient client = HttpClient.newHttpClient()) {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(apiUrl + "/b2api/v4/b2_create_key"))
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
