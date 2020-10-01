require "pry"
require 'rest-client'
require 'rainbow'
require "tty-prompt"

class SpontaneousDecision
# prompt = TTY::Prompt.new
    def self.welcome
        prompt = TTY::Prompt.new
        welcome = prompt.select("Welcome! Please log in or sign up.") do |menu|
            menu.choice "Log in"
            menu.choice "Sign up"
        end
        if welcome == "Log in"
            sleep (1)
            SpontaneousDecision.log_in
        elsif welcome == "Sign up"
            sleep (1)
            SpontaneousDecision.sign_up
        end
    end

    def self.sign_up
        prompt = TTY::Prompt.new
        name = prompt.ask("Name?") 
        sleep (1)
        puts "Welcome #{name}! Just a few questions before we provide a spontaneous option for you."
        sleep (1)
        email = prompt.ask("Enter your Email", validate: /\A\w+@\w+\.\w+\Z/) 
        password = prompt.mask("Create a password")
        mobile = prompt.ask("Phone number?", required: true)
        zip = prompt.ask("Zip?", validate: /\A\d{5}\Z/)
        puts "Thank you for signing up #{name}!"
        # user = User.create(name: name, email: email, password: password, location: zip, mobile: mobile)
        sleep (1)
        # @user = User.all.find_by(name: name, email: email, password: password, location: zip, mobile: mobile)
        puts "User created. Quiz next!"
        SpontaneousDecision.level
    end

    def self.log_in
        prompt = TTY::Prompt.new
        email = prompt.ask("Enter your Email")
        password = prompt.mask("Enter your Password")
        if User.find_by(name: name, email: email, password: password, location: zip, mobile: mobile)
            @user = User.all.find_by(name: name, email: email, password: password, location: zip, mobile: mobile)
            SpontaneousDecision.level
        else
            system("clear")
            SpontaneousDecision.sign_up
        end
    end

    def self.level
        prompt = TTY::Prompt.new
        puts "Hello, #{@user.name}! How risky would you like your Spontaneous Decison to be?"
        risk_level = prompt.select("Risk level?", risk_level) do |menu|
            menu.choice "high"
            menu.choice "medium"
            menu.choice "low"
        end
    end

end

SpontaneousDecision.welcome



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