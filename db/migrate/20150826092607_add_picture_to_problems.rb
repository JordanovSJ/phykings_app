class AddPictureToProblems < ActiveRecord::Migration
  def change
    add_column :problems, :picture, :string
  end
end
