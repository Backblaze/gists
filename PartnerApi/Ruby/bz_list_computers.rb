# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

api_url = '' # Provided by b2_authorize_account
auth_token = '' # Provided by b2_authorize_account
account_id = '' # Provided by b2_list_group_members

uri = URI("#{api_url}/api/backup/v1/bz_list_computers")

request = Net::HTTP::Post.new(uri)
request['Authorization'] = auth_token
request['Content-Type']  = 'application/json'
request.body = { accountId: account_id }.to_json

response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
  http.request(request)
end

puts response.body
