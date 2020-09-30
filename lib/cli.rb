def run
    greeting
end


def greeting
    puts "Welcome! Let's find a spontaneous decision near you."
    sleep(3)
    sign_up
end

def sign_up
    puts "Please enter your name:"
    answer = gets.chomp.downcase
    @user = User.find_or_create_by(username: answer)
    #want to collect the user name (or login?)
    #sign_up = User.create(username: answer)
    #login = User.find_by(username: answer)
    sleep(3)
    puts "Just a few more questions #{@user.username.capitalize}!"
end

def user_number
    puts "Please enter your number:"
end

#sleep(1)