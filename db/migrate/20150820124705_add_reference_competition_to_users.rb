class AddReferenceCompetitionToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :competition, index: true, foreign_key: true
  end
end
