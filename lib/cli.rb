require "pry"
require 'rest-client'
require 'rainbow'
require "tty-prompt"

class SpontaneousDecision
# prompt = TTY::Prompt.new


    # def self.quiz
    #     prompt = TTY::Prompt.new
    #     result = prompt.collect do 
    #         key(:name).ask("Name?")
    #         puts "Welcome ****! Just a few questions before we provide a spontaneous option for you."
    #         key(:age).ask("Age?", convert: :int)
    #         key(:city).ask("City?", required: true)
    #         key(:zip).ask("Zip?", validate: /\A\d{5}\Z/)
    #     end
    #     sleep(1)
    #     puts "Thank you for giving us your data >:)"
    #     sleep(2)
    # end
    # result returns a hash w key/value pairs ex.{:name=>"Casey", :age=>19, :city=>"Brooklyn", :zip=>"11221"}


    def self.quiz
        prompt = TTY::Prompt.new
        name = prompt.ask("Name?") 
        sleep (1)
        puts "Welcome #{name}! Just a few questions before we provide a spontaneous option for you."
        sleep (1)
        email = prompt.ask("Email?", validate: /\A\w+@\w+\.\w+\Z/) 
        number = prompt.ask("Phone number?", required: true)
        city = prompt.ask("City?", required: true)
        zip = prompt.ask("Zip?", validate: /\A\d{5}\Z/)
        # user = User.create(name: name, location: zip)
        sleep(1)
        puts "Thank you for giving us your data >:)"
        sleep(2)
        SpontaneousDecision.stay_go
    end
SpontaneousDecision.quiz
    

# binding.pry

    def self.stay_go
        prompt = TTY::Prompt.new
        stay_go = prompt.select("Would you like to stay close to home, or go out?", stay_go) do |menu|
            menu.choice "Stay home"
            menu.choice "Go out"
        end
        if stay_go== "Stay home"
            puts "Randomized array of choices. Read a book"
        elsif stay_go == "Go out"
            SpontaneousDecision.level
        end
        sleep(1)
    end

    def self.level
        prompt = TTY::Prompt.new
        risk_level = prompt.select("What is your risk level?", risk_level) do |menu|
            menu.choice "high"
            menu.choice "medium"
            menu.choice "low"
        end
    end
binding.pry
end







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