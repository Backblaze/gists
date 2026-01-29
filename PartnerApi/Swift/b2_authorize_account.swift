import Foundation

let masterApplicationKeyId = ""  // Obtained from your B2 account page.
let masterApplicationKey = ""  // Obtained from your B2 account page.

let base64EncodedString = Data("\(masterApplicationKeyId):\(masterApplicationKey)".utf8)
  .base64EncodedString()

var request = URLRequest(
  url: URL(string: "https://api.backblazeb2.com/b2api/v4/b2_authorize_account")!)
request.setValue("Basic \(base64EncodedString)", forHTTPHeaderField: "Authorization")
let (data, response) = try await URLSession.shared.data(for: request)

print(String(decoding: data, as: UTF8.self))
