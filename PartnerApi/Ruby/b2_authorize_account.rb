# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'base64'

master_application_key_id = ''
master_application_key = ''

auth = Base64.strict_encode64("#{master_application_key_id}:#{master_application_key}")

request = Net::HTTP::Get.new(URI('https://api.backblazeb2.com/b2api/v4/b2_authorize_account'))
request['Authorization'] = "Basic #{auth}"

response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
  http.request(request)
end

puts response.body
