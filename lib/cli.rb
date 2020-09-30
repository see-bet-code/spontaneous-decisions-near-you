require "pry"
require 'rest-client'
require 'rainbow'
require "tty-prompt"

prompt = TTY::Prompt.new


# prompt.ask("What is your name?", default: ENV["USER"])

result = prompt.collect do
    key(:name).ask("Name?")
    # name = result[:name]
    puts "Welcome **NAME! Just a few questions before we provide a spontaneous option for you."
    
    key(:age).ask("Age?", convert: :int)
  
    # key(:address) do
    #   key(:street).ask("Street?", required: true)
      key(:city).ask("City?", required: true)
      key(:zip).ask("Zip?", validate: /\A\d{5}\Z/)
    # end
  end
# result returns a hash w key/value pairs ex.{:name=>"Casey", :age=>19, :city=>"Brooklyn", :zip=>"11221"}

sleep(1)
puts "Thank you for giving us your data >:)"
sleep(2)

stay_go = %w(home out)
prompt.select("Would you like to stay close to home, or go out?", stay_go)

sleep(1)


risk_level = %w(high medium low)
prompt.select("What is your risk level?", risk_level)

  binding.pry








# class Welcome
#     def run
#         greeting
#     end


#     def greeting
#         puts "Welcome! Let's find a spontaneous decision near you."
#         sleep(3)
#         sign_up
#     end

#     def sign_up
#         puts "Please enter your name:"
#         answer = gets.chomp.downcase
#         @user = User.find_or_create_by(name: answer)
#     #want to collect the user name (or login?)
#     #sign_up = User.create(username: answer)
#     #login = User.find_by(username: answer)
#         sleep(3)
#         puts "Just a few more questions #{@user.name.capitalize}!"
#         user_number
#     end

#     def user_number
#         puts "Please enter your number:"
#     end
# end
# #sleep(1)