class CreateBanks < ActiveRecord::Migration
  def change
    create_table :banks do |t|
      t.integer :total_gold
      t.integer :present_gold
      t.timestamps null: false
    end
  end
end
