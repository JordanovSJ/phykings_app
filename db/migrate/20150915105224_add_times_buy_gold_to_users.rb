class AddTimesBuyGoldToUsers < ActiveRecord::Migration
  def change
    add_column :users, :times_buy_gold, :integer, default: 0
  end
end
