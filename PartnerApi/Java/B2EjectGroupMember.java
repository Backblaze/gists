package com.backblaze.examples;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

public class B2EjectGroupMember {
    public static void main(String[] args) {
        String apiUrl = ""; // Provided by b2_authorize_account
        String accountAuthorizationToken = ""; // Provided by b2_authorize_account
        String adminAccountId = ""; // Provided by b2_authorize_account
        String groupId = ""; // Provided by b2_list_groups
        String memberAccountId = ""; // Provided by b2_create_group_member or b2_list_group_members

        String postParams = "{\"adminAccountId\":\"" + adminAccountId + "\",\"groupId\":\"" + groupId + "\",\"memberAccountId\":\"" + memberAccountId + "\"}";
        try (HttpClient client = HttpClient.newHttpClient()) {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(apiUrl + "/b2api/v4/b2_eject_group_member"))
                    .header("Authorization", accountAuthorizationToken)
                    .header("Content-Type", "application/json")
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
