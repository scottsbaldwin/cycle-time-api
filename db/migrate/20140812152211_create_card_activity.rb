class CreateCardActivity < ActiveRecord::Migration
  def change
    create_table :card_activities do |t|
      t.string :card_id
      t.string :list_id
      t.date   :entry_date
      t.date   :exit_date
      t.integer :time_in_list, default: nil
      t.integer :grouping_year
      t.integer :grouping_month
      t.integer :grouping_week

      t.timestamps
    end

    add_index :card_activities, :card_id
    add_index :card_activities, :list_id
    add_index :card_activities, [:grouping_year, :grouping_month]
    add_index :card_activities, [:grouping_year, :grouping_week]
  end
end
