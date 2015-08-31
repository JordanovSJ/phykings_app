class CreateUserProblemRelations < ActiveRecord::Migration
  def change
    create_table :user_problem_relations do |t|
      t.integer :viewer_id
      t.integer :seen_problem_id
      #~ t.references :viewer, references: :users, index: true, foreign_key: true
      #~ t.references :seen_problem, references: :problems, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :user_problem_relations, :viewer_id
    add_index :user_problem_relations, :seen_problem_id
    add_index :user_problem_relations, 
							[:viewer_id, :seen_problem_id], unique: true
  end
end
