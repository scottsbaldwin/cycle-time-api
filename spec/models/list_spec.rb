require 'spec_helper'

describe List do
  it "should belong to a board" do
    board = FactoryGirl.create(:board)
    list = FactoryGirl.create(:todo_list)
    expect(list.trello_board_id).to eq(board.trello_board_id)
  end

  it "should not allow duplicate trello list ids" do
    FactoryGirl.create(:todo_list)
    duplicate = FactoryGirl.build(:todo_list)
    expect(duplicate.valid?).to be_false
  end

  it "should have cards" do
    FactoryGirl.create(:entry_only_card)
    list = FactoryGirl.create(:todo_list)
    expect(list.card_activity.count).to be > 0
  end
end
