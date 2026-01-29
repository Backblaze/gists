using System.Text;

class Program
{
    static readonly HttpClient Http = new();

    static async Task Main()
    {
        const string apiUrl = ""; // Provided by b2_authorize_account
        const string authToken = ""; // Provided by b2_authorize_account
        const string adminAccountId = ""; // Provided by b2_authorize_account
        const string groupId = ""; // Provided by b2_list_groups
        const string memberAccountId = ""; // Provided by b2_create_group_member or b2_list_group_members

        var postData = $@" {{ ""adminAccountId"": ""{adminAccountId}"", ""groupId"": ""{groupId}"", ""memberAccountId"": ""{memberAccountId}"" }} ";

        Http.DefaultRequestHeaders.TryAddWithoutValidation("Authorization", authToken);

        var response = await Http.PostAsync(
            $"{apiUrl}/b2api/v4/b2_eject_group_member",
            new StringContent(postData, Encoding.UTF8, "application/json")
        );

        Console.WriteLine(await response.Content.ReadAsStringAsync());
    }
}