require 'trello'

Trello.configure do |config|
  config.developer_public_key = ENV['trello_public_key'] || "public key not set"
  config.member_token = ENV['trello_member_token'] || "member token not set"
end
