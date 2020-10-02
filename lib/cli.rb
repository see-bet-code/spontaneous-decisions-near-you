require "pry"
require 'rest-client'
require 'rainbow'
require "tty-prompt"
require "active_record"
require_all "app/models"
require_relative "./yelp_api.rb"
require_relative "./twilio_sms.rb"
require 'date'
require 'launchy'

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
        @user = User.create(name: name, email: email, password: password, location: zip, mobile: mobile, birthdate: Date.new(bday[0..3].to_i,bday[4..5].to_i, bday[6..7].to_i))
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
            sleep 2
            SpontaneousDecision.welcome
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
            self.review_historical_plans
        when "Delete your account forevahhh D:"
            self.delete_account
        else
            self.log_out
        end
    end
    
    def self.review_historical_plans
        if @user.plans.size > 0
            puts Rainbow("Look at all you've accomplished (´•ω•̥`)").magenta
            puts Rainbow("#{@user.name}, you have #{@user.plans.size} plan(s)!").magenta
        else
            puts "Looks like you haven't selected any plans yet."
            comment = @prompt.yes?("Do you want to generate a new one now?")
            comment == "Yes" || comment ? self.level : self.main_menu
        end
        puts "\n"
        filtered_history = self.disable_reviewed_plans.push("Nevermind, take me back")
        past_plan = @prompt.select("Which would you like to review?", filtered_history)
        if past_plan != "Nevermind, take me back"
            rating = @prompt.ask("On a scale of 1-10, how much did you enjoy this plan?") { |q| q.in("1-10") }
            comment = @prompt.yes?("Any additional comments?")
            input = comment == "Yes" || comment ? @prompt.ask("Enter additional comments") : ""
            plan = Plan.find_by(desc: past_plan)
            Review.create(user_id: @user.id, plan_id: 
            plan.id, rating: rating, comment: input)
            self.review_historical_plans
        else
            self.main_menu
        end
    end

    def self.disable_reviewed_plans
        @user.selected_plans.map do |x| 
            Review.find_by(plan_id: Plan.find_by(desc: x).id) ? \
                {name: x, disabled: "(Already reviewed )"} : x
        end
    end

    def self.log_out
        sleep(1)
        puts "See ya later!"
        sleep(1)
        system("clear")
    end

    def self.delete_account
        choice = @prompt.no?("oh no! Are you sure about this")
        case choice
        when "No"
            sleep 2
            puts "WHEW, you had us worried there."
            sleep 3
            self.main_menu
        else
            sleep 3
            puts "we'll miss you #{@user.name}! (◕︿◕✿)"
            User.delete(@user.id)
            sleep 5
            self.welcome
        end
    end

    def self.update_info
        update_info = @prompt.select("What wouuld you like to change?") do |menu|
            menu.choice "Update your password"
            menu.choice "Update your zip code"
            menu.choice "Update your mobile number"
            menu.choice "Return to main menu"
        end

        case update_info
        when "Update your password"
            self.password_update
        when "Update your zip code"
            self.zip_update
        when "Update your mobile number"
            self.mobile_update
        when "Return to main menu"
            self.main_menu
        else
        end
    end

    def self.password_update
        new_password = @prompt.ask("Please set your new password:")
        @user.update(password: new_password)
        puts "Success! Your password is updated."
        sleep(1)
        system("clear")
        SpontaneousDecision.log_in
    end

    def self.zip_update
        new_zip = @prompt.ask("Please update your zip-code:")
        @user.update(zip: new_zip)
        puts "Success! Your zip code is updated."
        sleep(1)
        system("clear")
        SpontaneousDecision.log_in
    end

    def self.mobile_update
        new_mobile = @prompt.ask("Please update your mobile number:")
        @user.update(mobile: new_mobile)
        puts "Success! Your mobile number is updated."
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
            menu.choice "Surprise me ¯\_(๑❛ᴗ❛๑)_/¯"
        end
        risk_id = risk_level != "Surprise me ¯\_(๑❛ᴗ❛๑)_/¯" ? RiskLevel.find_by(name: risk_level).id : [0..3].sample
        YelpAPI.generate_yelp_plans(age: @user.age, location: @user.location, user_id: @user.id, risk_level_id: risk_id)
        plan_options = Plan.where(risk_level_id: risk_id).sample(5).map {|p| p.desc }
        if plan_options.empty?
            puts "Wow, looks like we didn't find anything matching that risk level."
            sleep 2
            puts "Awkward..."
            sleep 1
            selected_plan_backup = @prompt.yes?("Are you sure you can handle this risk level?")
            if selected_plan_backup || selected_plan_backup == "Yes"
                YelpAPI.generate_yelp_plans(age: @user.age, location: @user.location, user_id: @user.id, risk_level_id: risk_id)
            else
                self.level
            end
        end
        selected_plan = @prompt.select("Choose a plan!", plan_options.push("Return to main menu"))
        self.main_menu if selected_plan == "Return to main menu"
        sleep 2
        plan = Plan.find_by(desc: selected_plan)
        plan.update(selected?: true, user_id: @user.id)
        self.check_out?(plan)
    end

    def self.check_out?(plan)
        choice = @prompt.yes?("Would you like to check out your selected plan now?")
        if choice == "Yes" || choice
            options = %w(Text)
            options += ["Open url in default browser"] if plan.url
            next_step = @prompt.select("Options below:", options)
            self.send_deets(next_step, plan)
            puts Rainbow("Have fun ♡♡♡").italic.teal
            
        else
            puts Rainbow("Returning to main menu...").italic.teal
            puts "\n"
            self.main_menu
        end
    end

    def self.send_deets(opt, plan)
        body = "Please find the deets of your plan below: \n#{plan.desc}"
        num = User.find(plan.user_id).mobile
        case opt
        when "Text"
            TwilioAPI.send_text(num, body)
        when "Open url in default browser"
            Launchy.open(plan.url)
        else
            puts "How did we get here???? I used to know you so well...."
        end
    end

end
