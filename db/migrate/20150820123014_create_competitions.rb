class CreateCompetitions < ActiveRecord::Migration
  def change
    create_table :competitions do |t|
      t.integer :n_players
      t.integer :length
      t.integer :entry_gold, default: 0
			
      t.timestamps null: false
    end
  end
end
