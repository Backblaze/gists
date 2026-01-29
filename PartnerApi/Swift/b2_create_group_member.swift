import Foundation

let apiUrl = ""  // Provided by b2_authorize_account
let accountAuthorizationToken = ""  // Provided by b2_authorize_account
let adminAccountId = ""  // Provided by accountId in b2_authorize_account
let groupId = ""  // Provided by b2_list_groups
let memberEmail = "new-group-member@mycompany.com"  // Email address for account being created

let postData: [String: Any] = [
  "adminAccountId": adminAccountId,
  "groupId": groupId,
  "memberEmail": memberEmail,
]

var request = URLRequest(url: URL(string: "\(apiUrl)/b2api/v4/b2_create_group_member")!)
request.httpMethod = "POST"
request.setValue(accountAuthorizationToken, forHTTPHeaderField: "Authorization")
request.setValue("application/json", forHTTPHeaderField: "Content-Type")
request.httpBody = try? JSONSerialization.data(withJSONObject: postData)

let (data, response) = try await URLSession.shared.data(for: request)

print(String(decoding: data, as: UTF8.self))
