require 'pry'
require 'pry-remote'
require 'pry-nav'

require 'json'

require 'pp'

LOGIN_MENU = "
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

If you want to signup, type:
> signup

If you want to login, type:
> login

To quit, type:
> quit

"

MAIN_MENU = "
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

To list hashkickers, type:
> list

To view someone's profile, type:
> view username

To post on someone's wall, type:
> post username

To log out, type:
> logout

To quit, type:
> quit

"

PROFILE_MENU = "
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

To set your location, type:
> location

To set your interests, type:
> interests

To set your profile picture, type:
> picture

To set your relationship status, type:
> relationship

To go back, type:
> back

"

PROFILE_INTERESTS_MENU = "
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

To set your favorite books, type:
> books

To set your favorite movies, type:
> movies

To set your favorite music, type:
> music

To set your favorite food, type:
> food

To go back, type:
> back
"

PROFILE_LOCATION_MENU = "
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

To set your hometown, type:
> hometown

To set your current location, type:
> current

To go back, type:
> back
"

def load_json_file( filename )
	JSON.parse( IO.read(filename) )
end
def write_json_file( object, filename )
	File.open(filename, 'w'){ |file| JSON.dump( object, file) }
end

def ask(string)
	puts string
	gets.chomp!
end

def signup
	while true
		puts
		req_username = ask('What would you like your username to be?')
		break if @hb_db.has_key?(req_username) == false
	end
	puts
	puts "That username is available."
	password_check = false
	while true
		password_1 = ask("Please enter a password.")
		puts
		password_2 = ask("Please re-enter your password.")
		break if password_1 == password_2
	end
	@hb_db[req_username] = Hash.new
	@hb_db[req_username][:password] = password_1
	puts
	puts 'Thank you. Your account has now been created. Please proceed to login.'
end

def login
	puts
	username = ask('Please enter your username:')
	password = ask('Please enter your password:')
	## Check if valid
	if @hb_db.has_key?(username) == true
		@user_status = 'logged_in' if @hb_db[username]['password'] == password
	end
	puts
	puts "You are now logged in." if @user_status == 'logged_in'
	puts "Your username or password was incorrect" if @user_status != 'logged_in'
end

def logout
	@user_status = nil
	puts "You have been logged out."
end


@user_status = nil

@hb_db = load_json_file( 'hb_db.json' )

while true

	until @user_status == 'logged_in'
		%x(clear)
		puts LOGIN_MENU
		user_entry = gets.chomp
		signup if user_entry == 'signup'
		login if user_entry == 'login'
		break if user_entry == 'quit'
	end

	while @user_status == 'logged_in'
		%(clear)
		puts MAIN_MENU
		user_entry = gets.chomp
		pp @hb_db.keys if user_entry == 'list'
		logout if user_entry == 'logout'
		break if user_entry == 'quit'
	end

	break if user_entry == 'quit'

end

write_json_file( @hb_db, 'hb_db.json')
puts "bye."