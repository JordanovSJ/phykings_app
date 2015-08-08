class CreateRelations < ActiveRecord::Migration
  def change
    create_table :relations do |t|
      t.integer :solver_id
      t.integer :solved_problem_id

      t.timestamps null: false
    end
    add_index :relations, :solver_id
    add_index :relations, :solved_problem_id
    add_index :relations, 
							[:solver_id, :solved_problem_id], unique: true
  end
end
