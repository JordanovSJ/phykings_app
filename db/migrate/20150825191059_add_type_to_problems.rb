class AddTypeToProblems < ActiveRecord::Migration
  def change
    add_column :problems, :target, :integer
  end
end
