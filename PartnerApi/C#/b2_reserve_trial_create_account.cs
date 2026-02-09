using System.Text;

class Program
{
    static readonly HttpClient Http = new();

    static async Task Main()
    {
        const string apiUrl = ""; // Provided by b2_authorize_account
        const string authToken = ""; // Provided by b2_authorize_account
        const string memberEmail = "new-b2-reserve-member@mycompany.com"; // Email address for account being created
        const int termInDays = 7; // Length of trial period in days
        const int storageInTB = 10; // Amount of storage in TB

        var postData = $@" {{ ""email"": ""{memberEmail}"", ""term"": {termInDays}, ""storage"": {storageInTB} }} ";

        Http.DefaultRequestHeaders.TryAddWithoutValidation("Authorization", authToken);

        var response = await Http.PostAsync(
            $"{apiUrl}/b2api/v4/b2_reserve_trial_create_account",
            new StringContent(postData, Encoding.UTF8, "application/json")
        );

        Console.WriteLine(await response.Content.ReadAsStringAsync());
    }
}