import Foundation

let apiUrl = ""  // Provided by b2_authorize_account
let accountAuthorizationToken = ""  // Provided by b2_authorize_account
let memberEmail = "new-b2-reserve-member@mycompany.com"  // Email address for account being created
let term_in_days = 7  // Length of trial period in days
let storage_in_tb = 10  // Amount of storage in TB

let postData: [String: Any] = [
  "email": memberEmail,
  "term": term_in_days,
  "storage": storage_in_tb,
]

var request = URLRequest(url: URL(string: "\(apiUrl)/b2api/v4/b2_reserve_trial_create_account")!)
request.httpMethod = "POST"
request.setValue(accountAuthorizationToken, forHTTPHeaderField: "Authorization")
request.setValue("application/json", forHTTPHeaderField: "Content-Type")
request.httpBody = try? JSONSerialization.data(withJSONObject: postData)

let (data, response) = try await URLSession.shared.data(for: request)

print(String(decoding: data, as: UTF8.self))
