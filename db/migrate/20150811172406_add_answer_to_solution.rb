class AddAnswerToSolution < ActiveRecord::Migration
  def change
		add_column :solutions, :answer, :integer
		add_column :solutions, :degree_of_answer, :integer
		add_column :solutions, :units_of_answer, :string
  end
end
