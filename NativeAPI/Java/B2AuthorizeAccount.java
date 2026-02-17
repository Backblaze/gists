package com.backblaze.examples;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.Base64;

public class B2AuthorizeAccount {
    public static void main(String[] args) {
        // You can use either your master application key, provided by the B2 web console,
        // or an application key created in the B2 web console or using the b2_create_key
        // API.
        String applicationKeyId = "";
        String applicationKey = "";

        String headerForAuthorizeAccount = "Basic " + Base64.getEncoder().encodeToString((applicationKeyId + ":" + applicationKey).getBytes());
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
