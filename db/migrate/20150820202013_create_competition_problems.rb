class CreateCompetitionProblems < ActiveRecord::Migration
  def change
    create_table :competition_problems do |t|
      t.integer :problem_id
      t.integer :competition_id

      t.timestamps null: false
    end
    add_index :competition_problems, :problem_id
    add_index :competition_problems, :competition_id
    add_index :competition_problems, 
							[:problem_id, :competition_id], unique: true
  end
end
