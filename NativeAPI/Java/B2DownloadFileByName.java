package com.backblaze.examples;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

public class B2DownloadFileByName {
    public static void main(String[] args) {
        String downloadUrl = ""; // Provided by b2_authorize_account
        String accountAuthorizationToken = ""; // Provided by b2_authorize_account
        String bucketName = ""; // The bucket name where the file exists
        String fileName = ""; // The file name of the file you want to download.

        try (HttpClient client = HttpClient.newHttpClient()) {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(downloadUrl + "/file/" + bucketName + "/" + fileName))
                    .header("Authorization", accountAuthorizationToken)
                    .GET()
                    .build();
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
            String downloadedData = response.body();
            System.out.println(downloadedData);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
