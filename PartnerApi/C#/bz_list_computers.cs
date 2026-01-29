using System.Text;

class Program
{
    static readonly HttpClient Http = new();

    static async Task Main()
    {
        const string apiUrl = ""; // Provided by b2_authorize_account
        const string authToken = ""; // Provided by b2_authorize_account
        const string accountId = ""; // Provided by b2_list_group_members

        var postData = $@" {{ ""accountId"": ""{accountId}"" }} ";

        Http.DefaultRequestHeaders.TryAddWithoutValidation("Authorization", authToken);

        var response = await Http.PostAsync(
            $"{apiUrl}/api/backup/v1/bz_list_computers",
            new StringContent(postData, Encoding.UTF8, "application/json")
        );

        Console.WriteLine(await response.Content.ReadAsStringAsync());
    }
}