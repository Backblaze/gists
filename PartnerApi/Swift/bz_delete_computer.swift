import Foundation

let apiUrl = ""  // Provided by b2_authorize_account
let accountAuthorizationToken = ""  // Provided by b2_authorize_account
let accountId = ""  // Provided by b2_authorize_account
let computerId = ""  // Provided by bz_list_computers

let postData: [String: Any] = [
  "accountId": accountId,
  "computerId": computerId,
]

var request = URLRequest(url: URL(string: "\(apiUrl)/api/backup/v1/bz_delete_computer")!)
request.httpMethod = "POST"
request.setValue(accountAuthorizationToken, forHTTPHeaderField: "Authorization")
request.setValue("application/json", forHTTPHeaderField: "Content-Type")
request.httpBody = try? JSONSerialization.data(withJSONObject: postData)

let (data, response) = try await URLSession.shared.data(for: request)

print(String(decoding: data, as: UTF8.self))
