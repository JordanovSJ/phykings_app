class AddResultsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :results, :text
  end
end
