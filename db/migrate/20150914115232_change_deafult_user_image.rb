class ChangeDeafultUserImage < ActiveRecord::Migration
  def change
		change_column :users, :image, :string, default: nil
  end
end
