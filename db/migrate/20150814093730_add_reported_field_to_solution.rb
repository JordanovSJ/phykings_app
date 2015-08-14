class AddReportedFieldToSolution < ActiveRecord::Migration
  def change
		 add_column :solutions, :reported, :boolean, default: false
  end
end
