class AddVotesToSolutions < ActiveRecord::Migration
  def change
    add_column :solutions, :upvotes, :integer, default: 0
    add_column :solutions, :downvotes, :integer, default: 0
  end
end
