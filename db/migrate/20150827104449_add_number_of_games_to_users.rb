class AddNumberOfGamesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :number_free_games, :integer, default: 0
    add_column :users, :number_premium_games, :integer, default: 0
  end
end
