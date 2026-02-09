# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

api_url = '' # Provided by b2_authorize_account
auth_token = '' # Provided by b2_authorize_account
member_email = 'new-b2-reserve-member@mycompany.com' # Email address for account being created
term_in_days = 7 # Length of trial in days
storage_in_tb = 10 # Amount of storage in TB

uri = URI("#{api_url}/b2api/v4/b2_reserve_trial_create_account")

request = Net::HTTP::Post.new(uri)
request['Authorization'] = auth_token
request['Content-Type']  = 'application/json'
request.body = { email: member_email, term: term_in_days, storage: storage_in_tb }.to_json

response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
  http.request(request)
end

puts response.body
