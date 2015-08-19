class AddVotingToProblems < ActiveRecord::Migration
  def change
    add_column :problems, :rating, :float
    add_column :problems, :votes, :integer
  end
end
