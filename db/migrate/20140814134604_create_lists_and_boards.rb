class CreateListsAndBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.string :trello_board_id
      t.string :name
      t.timestamps
    end

    add_index :boards, :trello_board_id

    create_table :lists do |t|
      t.string :trello_list_id
      t.string :name
      t.string :trello_board_id
      t.timestamps
    end

    add_index :lists, :trello_list_id
    add_index :lists, :trello_board_id
  end
end
