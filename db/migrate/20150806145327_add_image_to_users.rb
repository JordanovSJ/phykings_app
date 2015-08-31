class AddImageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :image, :string, default: DEF_IMAGE
  end
end
