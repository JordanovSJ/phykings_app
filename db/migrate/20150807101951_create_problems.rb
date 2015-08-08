class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.string :title
      t.text :content
			t.float :answer
			t.references :creator, references: :creator, index: true, foreign_key: true
      t.timestamps null: false
    end
    add_index :problems, [:creator_id, :created_at]
  end
end