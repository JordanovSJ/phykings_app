class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.string :title
      t.text :content
			t.float :answer
      t.timestamps null: false
    end
  end
end
