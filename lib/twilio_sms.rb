require 'twilio-ruby'
require 'sinatra'

class TwilioSMS 
    @account_sid = ENV['TWILIO_ACCT_SID']
    @auth_token = ENV['TWILIO_AUTH_TOKEN']
    @client = Twilio::REST::Client.new(@account_sid, @auth_token)

    FROM = '+12059527201' # Your Twilio number
    @to = ''

    # validation_request = client.validation_requests
    #                             .create(
    #                                 friendly_name: '+16785925359',
    #                                 phone_number: '+16785925359'
    #                                 )
    def assign_to(mobile)
        @to = '+1' + mobile # already verified mobile number
    end

    def send_text(body)
        client.messages.create(
            from: @from,
            to: @to,
            body: body
        )
    end

    def dynmamic_auto_reply
        post '/sms' do
            # transform request body to lowercase
            body = params['Body'].downcase

            twiml = Twilio::TwiML::MessagingResponse.new do |resp|
                if body == 'hello'
                    resp.message body: 'Hi!'
                elsif body == 'bye'
                    resp.message body: 'Goodbye </3'
                end
            end

        twiml.to_s
        end
    end

end


