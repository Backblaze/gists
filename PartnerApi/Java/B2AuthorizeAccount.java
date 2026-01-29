package com.backblaze.examples;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.Base64;

public class B2AuthorizeAccount {
    public static void main(String[] args) {
        String masterApplicationKeyId = ""; // Obtained from your B2 account page.
        String masterApplicationKey = ""; // Obtained from your B2 account page.
        String headerForAuthorizeAccount = "Basic " + Base64.getEncoder().encodeToString((masterApplicationKeyId + ":" + masterApplicationKey).getBytes());
        try (HttpClient client = HttpClient.newHttpClient()) {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create("https://api.backblazeb2.com/b2api/v4/b2_authorize_account"))
                    .header("Authorization", headerForAuthorizeAccount)
                    .GET()
                    .build();
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
            String jsonResponse = response.body();
            System.out.println(jsonResponse);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
