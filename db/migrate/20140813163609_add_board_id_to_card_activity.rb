class AddBoardIdToCardActivity < ActiveRecord::Migration
  def change
    add_column :card_activities, :board_id, :string
  end
end
