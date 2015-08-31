class AddFreeGoldFieldToUser < ActiveRecord::Migration
  def change
    add_column :users, :got_free_gold, :boolean, default: false
  end
end
