# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# One admin user

user_admin = User.new( first_name: "user_admin",
											 last_name: "user_admin",
											 age: 25,
											 country: "United States",
											 email: "admin@abv.bg",
											 password: "foobar00",
											 password_confirmation: "foobar00" )
user_admin.skip_confirmation!
user_admin.save

# One moderator user

user_mod = User.new( first_name: "user_mod",
											 last_name: "user_mod",
											 age: 25,
											 country: "United States",
											 email: "mod@abv.bg",
											 password: "foobar00",
											 password_confirmation: "foobar00" )
user_mod.skip_confirmation!
user_mod.save

# 5 normal users

5.times do |n|
	user = User.new( first_name: "user_#{n+1}",
									 last_name: "user_#{n+1}",
									 age: 25,
									 country: "United States",
									 email: "user_#{n+1}@abv.bg",
									 password: "foobar00",
									 password_confirmation: "foobar00" )
	user.skip_confirmation!
	user.save
end

# n problems for user_n
User.all.each_with_index do |user_n, n|
	(n+1).times do |i|
		user_n.uploaded_problems.create!( title: "problem_#{n+1}_#{i+1}",
																			content: "This is problem #{i+1} of #{user_n.first_name}",
																			answer: 24,
																			degree_of_answer: 2,
																			units_of_answer: "\\text{kg}",
																			category: "Electromagnetism",
																			difficulty: (i%10)+1,
																			length: 60 )
	end
end

# Relations between consecutive users' problems and
# Solutions to the even problems (odd index)

N_users = User.count

User.all.each do |u|
	User.find( (u.id)%N_users + 1 ).uploaded_problems.each_with_index do |p, i|
		if p.present?
			rel = UserProblemRelation.create!( viewer_id: u.id,
																				 seen_problem_id: p.id )
			if i%2 == 1
				Solution.create!( content: "This is a solution.",
													user_problem_relation_id: rel.id,
													answer: 24,
													degree_of_answer: 2,
													reported: false )
				rel.update_attributes(provided_with_solution: true)
			end
		end
	end
end

# 

##############################################

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
