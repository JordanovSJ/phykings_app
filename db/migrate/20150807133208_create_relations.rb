class CreateRelations < ActiveRecord::Migration
  def change
    create_table :relations do |t|
      t.integer :user_id
      t.integer :problem_id

      t.timestamps null: false
    end
    add_index :relations, :user_id
    add_index :relations, :problem_id
    add_index :relations, 
							[:user_id, :problem_id], unique: true
  end
end
