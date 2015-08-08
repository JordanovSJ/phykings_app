# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


pe60 = User.new(
						first_name: "pe6o",
						last_name: "nenko",
		
						age: 20,
							country: "Bulgaria",
             email: "pe6o@abv.bg",
             password:              "sa6oalex",
             password_confirmation: "sa6oalex",
)

pe60.skip_confirmation!
pe60.save
   
   
 
sa6o = User.new(
						first_name: "sa6o",
						last_name: "nenko",

						
						age: 20,
							country: "Bulgaria",
             email: "sa6oalex@abv.bg",
             password:              "sa6oalex",
             password_confirmation: "sa6oalex",
)

pe60.skip_confirmation!
pe60.save 
         

problem1=Problem.create!(
							title: "sopol1",
							content: "elza",
							creator_id: 1,
)


problem2=Problem.create!(
							title: "sopol2",
							content: "elza",
							creator_id: 1,
)

problem3=Problem.create!(
							title: "sopol3",
							content: "elza",
							creator_id: 2,						
)

