require 'rubygems'
require 'twilio-ruby'

account_sid = ENV["TWILIO_ACCT_SID"]
auth_token = ENV["TWILIO_AUTH_TOKEN"]
client = Twilio::REST::Client.new(account_sid, auth_token)

from = '+12059527201' # Your Twilio number

validation_request = client.validation_requests
                            .create(
                                friendly_name: '+16785925359',
                                phone_number: '+16785925359'
                                )

to = '+16785925359' # Your mobile phone number

# client.messages.create(
# from: from,
# to: to,
# body: "It's ya boi! well me!"
# )
