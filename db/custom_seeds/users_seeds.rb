###########################################################
#REAL sseeeddss!!!!
#########################################################


# real admin user 1

user_admin1 = User.new( first_name: "Aleksandar",
											 last_name: "Sasho",
											 age: 23,
											 country: "Bulgaria",
											 email: "sasho.alex.sk@gmail.com",
											 password: "tarator1elza",
											 password_confirmation: "tarator1elza",
											 admin: true )
user_admin1.skip_confirmation!
user_admin1.save


# real admin user 1

user_admin2 = User.new( first_name: "Jordan",
											 last_name: "Jordanov",
											 age: 21,
											 country: "Bulgaria",
											 email: "jordanovsj@gmail.com",
											 password: "tarator2elza",
											 password_confirmation: "tarator2elza",
											 admin: true )
user_admin2.skip_confirmation!
user_admin2.save
