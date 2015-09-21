class CreateUserSolutionRelations < ActiveRecord::Migration
  def change
    create_table :user_solution_relations do |t|
      t.integer :viewer_id
      t.integer :seen_solution_id
			
      t.timestamps null: false
    end
    add_index :user_solution_relations, :viewer_id
    add_index :user_solution_relations, :seen_solution_id
    add_index :user_solution_relations, 
							[:viewer_id, :seen_solution_id], unique: true
  end
end
