class AddAnswerToSolution < ActiveRecord::Migration
  def change
		add_column :solutions, :answer, :integer
		add_column :solutions, :degree_of_answer, :integer
  end
end
