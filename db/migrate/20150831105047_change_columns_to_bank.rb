class ChangeColumnsToBank < ActiveRecord::Migration
  def change
		change_column :banks, :total_gold, :bigint
		change_column :banks, :present_gold, :bigint
  end
end
