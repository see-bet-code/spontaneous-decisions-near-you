require 'twilio-ruby'
require 'sinatra'

post '/sms' do
    # transform request body to lowercase
    body = params['Body'].downcase

    twiml = Twilio::TwiML::MessagingResponse.new do |resp|
        if body == 'hello' || body == 'Hello'
            resp.message body: 'Hi!'
        elsif body == 'bye' || body == 'Bye'
            resp.message body: 'Goodbye </3'
        end
    end

    twiml.to_s
end
