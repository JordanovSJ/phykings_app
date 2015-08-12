class AddFieldsToProblems < ActiveRecord::Migration
  def change
    add_column :problems, :degree_of_answer, :integer
    add_column :problems, :units_of_answer, :string
    add_column :problems, :category, :string
    add_column :problems, :difficulty, :integer
    add_column :problems, :length, :integer


  end
end
