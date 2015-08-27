class AddCheckedToProblems < ActiveRecord::Migration
  def change
    add_column :problems, :checked, :boolean, default: false
  end
end
