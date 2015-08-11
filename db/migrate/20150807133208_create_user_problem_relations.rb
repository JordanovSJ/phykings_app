class CreateUserProblemRelations < ActiveRecord::Migration
  def change
    create_table :user_problem_relations do |t|
      t.integer :viewer_id
      t.integer :seen_problem_id

      t.timestamps null: false
    end
    add_index :user_problem_relations, :viewer_id
    add_index :user_problem_relations, :seen_problem_id
    add_index :user_problem_relations, 
							[:viewer_id, :seen_problem_id], unique: true
  end
end
