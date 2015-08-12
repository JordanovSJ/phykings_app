class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.string :title
      t.text :content
			t.integer :answer
			t.references :creator, references: :users, index: true, foreign_key: true
      t.timestamps null: false
    end
    add_index :problems, [:creator_id, :created_at]
  end
end
