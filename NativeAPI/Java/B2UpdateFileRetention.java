package com.backblaze.examples;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

public class B2UpdateFileRetention {
    public static void main(String[] args) {
        String apiUrl = ""; // Provided by b2_authorize_account
        String accountAuthorizationToken = ""; // Provided by b2_authorize_account
        String fileId = "";  // The fileId of the file you want to update
        String fileName = ""; // Name of the file you want to update
        String mode = ""; // "governance" or "compliance"
        long retainUntilTimestamp = 0; // Milliseconds since 1/1/1970

        String postParams = "{" +
                "\"fileId\":\"" + fileId + "\"," +
                "\"fileName\":\"" + fileName + "\"," +
                "\"fileRetention\": {" +
                "\"mode\": \"" + mode + "\"," +
                "\"retainUntilTimestamp\":" +  retainUntilTimestamp +
                "}" +
                "}";

        System.out.println(postParams);

        try (HttpClient client = HttpClient.newHttpClient()) {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(apiUrl + "/b2api/v4/b2_update_file_retention"))
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
