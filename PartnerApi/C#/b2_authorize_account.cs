using System.Net.Http.Headers;
using System.Text;

class Program
{
    static readonly HttpClient Http = new();

    static async Task Main()
    {
        const string masterApplicationKeyId = ""; // Obtained from your B2 account page
        const string masterApplicationKey = ""; // Obtained from your B2 account page

        Http.DefaultRequestHeaders.Authorization =
            new AuthenticationHeaderValue("Basic",
                Convert.ToBase64String(Encoding.UTF8.GetBytes($"{masterApplicationKeyId}:{masterApplicationKey}")));

        var json = await Http.GetStringAsync("https://api.backblazeb2.com/b2api/v4/b2_authorize_account");

        Console.WriteLine(json);
    }
}