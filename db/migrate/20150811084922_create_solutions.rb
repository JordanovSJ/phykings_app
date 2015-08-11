class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.text :content
      t.references :user_problem_relation, index: true, foreign_key: true
      t.timestamps null: false
    end
    add_index :solutions, [:user_problem_relation_id, :created_at]
  end
end
