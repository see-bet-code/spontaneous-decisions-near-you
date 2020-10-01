require "pry"
require 'rest-client'
require 'rainbow'
require "tty-prompt"
require "active_record"
require_all "app/models"
require_relative "./yelp_api.rb"
require 'date'

class SpontaneousDecision
    @prompt = TTY::Prompt.new
    
    def self.welcome
        welcome = @prompt.select("Welcome! Please log in or sign up.") do |menu|
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
        name = @prompt.ask("Name?") 
        sleep (1)
        puts "Welcome #{name}! Just a few questions before we provide a spontaneous option for you."
        sleep (1)
        email = @prompt.ask("Enter your Email", validate: /\A\w+@\w+\.\w+\Z/) 
        password = @prompt.mask("Create a password")
        bday = @prompt.ask("Enter date of birth (YYYYMMDD):", validate: /\A\d{8}\Z/)
        mobile = @prompt.ask("Phone number?", required: true)
        zip = @prompt.ask("Zip?", validate: /\A\d{5}\Z/)
        puts "Thank you for signing up #{name}!"
        @user = User.create(name: name, email: email, password: password, location: zip, mobile: mobile, birthdate: DateTime.new(bday[0..3].to_i,bday[4..5].to_i, bday[6..7].to_i))
        sleep (1)
        puts "User created. Quiz next!"
        SpontaneousDecision.main_menu
    end

    def self.log_in
        email = @prompt.ask("Enter your Email")
        password = @prompt.mask("Enter your Password")
        if User.find_by(email: email, password: password)
            @user = User.find_by(email: email, password: password)
            SpontaneousDecision.main_menu
        else
            system("clear")
            puts "Hey, that doesn't match our records. Try again!"
            SpontaneousDecision.sign_up
        end
    end

    def self.main_menu
        puts "Hello, #{@user.name}! How can we help?"
        main_menu_choice = @prompt.select("Main menu options:") do |menu|
            menu.choice "Update your info"
            menu.choice "Find something to do"
            menu.choice "Review historical plans"
            menu.choice "Delete your account forevahhh D:"
            menu.choice "Exit into the real world"
        end

        case main_menu_choice
        when "Update your info"
            self.update_info
        when "Find something to do"
            self.level
        when "Review historical plans"
            self.historical_plans
        when "Delete your account forevahhh D:"
            self.delete_account
        when "Exit into the real world"
            self.log_out
        else
        end
    end
    
    def self.historical_plans
        puts @user.selected_plans
        self.main_menu
    end

    def self.log_out
        sleep(1)
        puts "See ya later!"
        sleep(1)
        system("clear")
    end

    def self.delete_account
    end

    def self.update_info
        update_info = @prompt.select("What wouuld you like to change?") do |menu|
            menu.choice "Update your password"
            menu.choice "Update your zip code"
            menu.choice "Return to main menu"
        end

        case update_info
        when "Update your password"
            self.password_update
        when "Update your zip code"
            self.zip_update
        when "Return to main menu"
            self.main_menu
        else
        end
    end

    def self.password_update
        new_password = @prompt.ask("Please set your new password:")
        @user.update(password: new_password)
        puts "Your password is updated!"
        sleep(1)
        system("clear")
        SpontaneousDecision.log_in
    end

    def self.zip_update
        new_zip = @prompt.ask("Please update your zip-code:")
        @user.update(zip: new_zip)
        puts "Your zip code is updated!"
        sleep(1)
        system("clear")
        SpontaneousDecision.log_in
    end

    def self.level
        puts "Hello, #{@user.name}! How risky would you like your Spontaneous Decison to be?"
        risk_level = @prompt.select("Risk level?") do |menu|
            menu.choice "high"
            menu.choice "medium"
            menu.choice "low"
        end
        risk_id = RiskLevel.find_by(name: risk_level).id
        plan_options = Plan.where(risk_level_id: risk_id).sample(5).map {|p| p.desc }
        selected_plan = @prompt.select("Choose a plan!", plan_options)
        #proposed = PLan.inside.sample(2) + Plan
        Plan.find_by(desc: selected_plan).update(selected?: true, user_id: @user.id)
        self.main_choice
    end

end
