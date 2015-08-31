class CreateBanks < ActiveRecord::Migration
  def change
    create_table :banks do |t|
      t.integer :total_gold, :limit => 8
      t.integer :present_gold, :limit => 8
      t.timestamps null: false
    end
  end
end
