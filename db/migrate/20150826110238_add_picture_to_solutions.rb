class AddPictureToSolutions < ActiveRecord::Migration
  def change
    add_column :solutions, :picture, :string
  end
end
