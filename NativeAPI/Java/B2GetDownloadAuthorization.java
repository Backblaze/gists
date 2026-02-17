package com.backblaze.examples;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

public class B2GetDownloadAuthorization {
    public static void main(String[] args) {
        String apiUrl = ""; // Provided by b2_authorize_account
        String accountAuthorizationToken = ""; // Provided by b2_authorize_account
        String bucketId = ""; // The bucket that files can be downloaded from
        String fileNamePrefix = "" ; // The file name prefix of files the download authorization will allow
        int validDuration = 86400; // The number of seconds the authorization is valid for

        String postParams = "{" +
                "\"bucketId\":\"" + bucketId + "\"," +
                "\"fileNamePrefix\":\"" + fileNamePrefix + "\"," +
                "\"validDurationInSeconds\":" + validDuration +
                "}";
        try (HttpClient client = HttpClient.newHttpClient()) {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(apiUrl + "/b2api/v4/b2_get_download_authorization"))
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
