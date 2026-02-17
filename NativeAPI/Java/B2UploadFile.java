package com.backblaze.examples;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class B2UploadFile {
    public static void main(String[] args) {
        String uploadUrl = ""; // Provided by b2_get_upload_url
        String uploadAuthorizationToken = ""; // Provided by b2_get_upload_url
        String fileName = "typing_test.txt"; // The name of the file you are uploading
        String contentType = "text/plain"; // The content type of the file
        byte[] fileData = {}; // Binary file content to upload

        String sha1 = sha1(fileData);
        try (HttpClient client = HttpClient.newHttpClient()) {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(uploadUrl))
                    .headers(
                            "Authorization", uploadAuthorizationToken,
                            "X-Bz-File-Name", fileName,
                            "X-Bz-Content-Sha1",  sha1,
                            "Content-Type", contentType
                    )
                    .POST(HttpRequest.BodyPublishers.ofByteArray(fileData))
                    .build();
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
            String jsonResponse = response.body();
            System.out.println(jsonResponse);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static String sha1(byte[] input) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-1");
            byte[] hashBytes = md.digest(input);
            StringBuilder hexString = new StringBuilder();
            for (byte b : hashBytes) {
                String hex = String.format("%02x", b);
                hexString.append(hex);
            }

            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }
}
