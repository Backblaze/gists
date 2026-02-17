package com.backblaze.examples;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

public class B2SetBucketNotificationRules {
    public static void main(String[] args) {
        String apiUrl = ""; // Provided by b2_authorize_account
        String accountAuthorizationToken = ""; // Provided by b2_authorize_account
        String bucketId = ""; // Provided by b2_create_bucket or b2_list_buckets
        String eventTypes = "[" + // Event types that will trigger the rule
                "\"b2:ObjectCreated:Upload\"," +
                "\"b2:ObjectCreated:MultipartUpload\"" +
                "]";
        String ruleName = ""; // Name of the rule you are creating
        String prefix = ""; // Restrict rule to files with names starting with this prefix (optional)
        String url = ""; // Your webhook URL

        String postParams = "{" +
                "\"bucketId\": \"" + bucketId + "\"," +
                "\"eventNotificationRules\": [" +
                "{" +
                "\"eventTypes\": \"" + eventTypes + "\"," +
                "\"isEnabled\": true," +
                "\"name\": \"" + ruleName + "\"," +
                "\"objectNamePrefix\": \"" + prefix + "\"," +
                "\"targetConfiguration\": {" +
                "\"targetType\": \"webhook\"," +
                "\"url\": \"" + url + "\"" +
                "}" +
                "}" +
                "]" +
                "}";

        try (HttpClient client = HttpClient.newHttpClient()) {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(apiUrl + "/b2api/v4/b2_set_bucket_notification_rules"))
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
