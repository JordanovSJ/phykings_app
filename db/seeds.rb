# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


pe60 = User.new(
						first_name: "user 1",
						last_name: "nenko",
		
						age: 20,
							country: "Bulgaria",
             email: "pe6o@abv.bg",
             password:              "password",
             password_confirmation: "password",
)

pe60.skip_confirmation!
pe60.save
   
   
 
sa6o = User.new(
						first_name: "user 2",
						last_name: "nenko",

						
						age: 20,
							country: "Bulgaria",
             email: "unufri@abv.bg",
             password:              "sa6oalex",
             password_confirmation: "sa6oalex",
)

sa6o.skip_confirmation!
sa6o.save
         

problem1=Problem.create!(
							title: "sopol1",
							content: "elza",
							answer: 24,
							degree_of_answer: 2,
							units_of_answer: "nenkos",
							category: "Electromagnetism",
							difficulty: 10,
							length: 60,
							creator_id: 1,
)


problem2=Problem.create!(
							title: "sopol2",
							content: "elza",
							answer: 24,
							degree_of_answer: 2,
							units_of_answer: "nenkos",
							category: "Electromagnetism",
							difficulty: 10,
							length: 60,
							
							creator_id: 1,
)

problem3=Problem.create!(
							title: "sopol3",
							content: "elza",
							answer: 24,
							degree_of_answer: 2,
							units_of_answer: "nenkos",
							category: "Electromagnetism",
							difficulty: 10,
							length: 60,
							creator_id: 2,						
)

problem4=Problem.create!(
							title: "sopol4",
							content: "elza",
							answer: 24,
							degree_of_answer: 2,
							units_of_answer: "nenkos",
							category: "Electromagnetism",
							difficulty: 10,
							length: 60,
							creator_id: 2,
)

#~ relation1=UserProblemRelation.create!(
							#~ viewer_id: 1,
							#~ seen_problem_id: 1,
#~ )
#~ 
#~ relation2=UserProblemRelation.create!(
							#~ viewer_id: 1,
							#~ seen_problem_id: 3,
#~ )
#~ 
#~ 
#~ relation3=UserProblemRelation.create!(
							#~ viewer_id: 2,
							#~ seen_problem_id: 1,
#~ )
#~ 
#~ 
#~ solution1=Solution.create!(
						#~ content: "solution of problem 3 by user 1",
						#~ user_problem_relation_id: 2,
						#~ answer: 42,
						#~ degree_of_answer: 1,
						#~ units_of_answer: "lols",
#~ )
