using System.Text;

class Program
{
    static readonly HttpClient Http = new();

    static async Task Main()
    {
        const string apiUrl = ""; // Provided by b2_authorize_account
        const string authToken = ""; // Provided by b2_authorize_account
        const string adminAccountId = ""; // Provided by b2_authorize_account

        var postData = $@" {{ ""adminAccountId"": ""{adminAccountId}"" }} ";

        Http.DefaultRequestHeaders.TryAddWithoutValidation("Authorization", authToken);

        var response = await Http.PostAsync(
            $"{apiUrl}/b2api/v4/b2_list_groups",
            new StringContent(postData, Encoding.UTF8, "application/json")
        );

        Console.WriteLine(await response.Content.ReadAsStringAsync());
    }
}