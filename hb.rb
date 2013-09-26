require 'pry'
require 'pry-remote'
require 'pry-nav'
require 'pp'

LOGIN_MENU = "
If you want to signup, type:
> signup

If you want to login, type:
> login
"

MAIN_MENU = "
If you want to list hashkickers, type:
> list

If you want to view someone's profile, type:
> view username

If you want to post on someone's wall, type:
> post username

If you want to quit, type:
> quit
"

@hb_db = {}

@user_status = nil

def ask(string)
	puts string
	gets.chomp!
end

def signup
	while true
		requested_username = ask('What would you like your username to be?')
		break if @hb_db.has_key?(requested_username.to_sym) == false
	end
	puts "That username is available."
	password_check = false
	while true
		password_1 = ask("Please enter a password.")
		password_2 = ask("Please re-enter your password.")
		break if password_1 == password_2
	end
	@hb_db[requested_username.to_sym] = Hash.new
	@hb_db[requested_username.to_sym][:password] = password_1
	puts 'Thank you. Your account has now been created. Please proceed to login.'
end

def login
	username = ask('Please enter your username:')
	password = ask('Please enter your password:')
	## Check if valid
	if @hb_db.has_key?(username.to_sym) == true
		@user_status = 'logged_in' if @hb_db[username.to_sym][:password] == password
	end
	puts "You are now logged in." if @user_status == 'logged_in'
	puts "Your username or password was incorrect" if @user_status != 'logged_in'
end

until @user_status == 'logged_in'
	puts LOGIN_MENU
	user_entry = gets.chomp
	signup if user_entry == 'signup'
	login if user_entry == 'login'
	binding.pry
end

while true
	puts MAIN_MENU
	user_entry = gets.chomp
	pp @hb_db.keys if user_entry == 'list'
	break if user_entry == 'quit'
end