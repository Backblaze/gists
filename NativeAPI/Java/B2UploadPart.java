package com.backblaze.examples;

import java.io.File;
import java.io.FileInputStream;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;

public class B2UploadPart {
    public static void main(String[] args) {
        System.out.println("b2_upload_part");

        String uploadUrl = ""; // Provided by b2_get_upload_part_url
        String uploadAuthorizationToken = ""; // Provided by b2_get_upload_part_url
        int minimumPartSize = 0; // Provided by b2_authorize_account

        File localFile = new File("bigfile.dat");
        long localFileSize = localFile.length();
        int sizeOfPart = minimumPartSize;
        byte[] buffer = new byte[minimumPartSize];
        long totalBytesSent = 0;
        int partNo = 1;
        List<String> partSha1Array = new ArrayList<>(); // Used in b2_finish_large_file

        try (FileInputStream fileInputStream = new FileInputStream(localFile)) {
            while (totalBytesSent < localFileSize) {
                if ((localFileSize - totalBytesSent) < minimumPartSize) {
                    sizeOfPart = (int) (localFileSize - totalBytesSent);
                }
                fileInputStream.read(buffer, 0, sizeOfPart);
                String sha1 = sha1(buffer);
                partSha1Array.add(sha1);

                try (HttpClient client = HttpClient.newHttpClient()) {
                    HttpRequest request = HttpRequest.newBuilder()
                            .uri(URI.create(uploadUrl))
                            .headers(
                                    "Authorization", uploadAuthorizationToken,
                                    "X-Bz-Part-Number", String.valueOf(partNo),
                                    "X-Bz-Content-Sha1", sha1
                            )
                            .POST(HttpRequest.BodyPublishers.ofByteArray(buffer))
                            .build();
                    HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
                    String jsonResponse = response.body();
                    System.out.println(jsonResponse);
                }

                totalBytesSent += sizeOfPart;
                partNo++;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Use partSha1Array in b2_finish_large_file
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
