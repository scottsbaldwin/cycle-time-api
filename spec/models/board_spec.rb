require 'spec_helper'

describe Board do
  it "should have lists" do
    board = FactoryGirl.create(:board)
    FactoryGirl.create(:todo_list)
    FactoryGirl.create(:in_progress_list)
    FactoryGirl.create(:done_list)
    expect(board.lists.count).to eq(3)
  end

  it "should not allow duplicate trello board ids" do
    FactoryGirl.create(:board)
    duplicate = FactoryGirl.build(:board)
    expect(duplicate.valid?).to be_false
  end
end
