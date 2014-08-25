require 'spec_helper'

describe CardActivity do
  let(:creation_json) { File.read(File.expand_path("../../fixtures/card_creation.json", __FILE__)) }
  let(:update_json) { File.read(File.expand_path("../../fixtures/card_update.json", __FILE__)) }
  let(:move_list_json) { File.read(File.expand_path("../../fixtures/card_moves_list.json", __FILE__)) }
  let(:archived_json) { File.read(File.expand_path("../../fixtures/card_archived.json", __FILE__)) }
  let(:deleted_json) { File.read(File.expand_path("../../fixtures/card_deleted.json", __FILE__)) }
  let(:restored_json) { File.read(File.expand_path("../../fixtures/card_restored.json", __FILE__)) }
  subject { CardActivity }

  it "should enter a list and have a board" do
    action = JSON.parse(creation_json)['action']
    activity = subject.create_entry(action)
    expect(activity.id).to be > 0
    expect(activity.entry_date).to eq(Date.parse('2014-08-12'))
    expect(activity.grouping_year).to eq(2014)
    expect(activity.grouping_month).to eq(8)
    expect(activity.grouping_week).to eq(33)
    expect(activity.board.trello_board_id).to eq('52ceaa77156434cc72450c71')
  end

  it "should exit then enter a new list" do
    action = JSON.parse(move_list_json)['action']
    existing_card         = FactoryGirl.create(:entry_only_card, list_id: action['data']['listBefore']['id'])
    card_in_new_list      = subject.move_card_to_new_list(action)
    card_in_original_list = CardActivity.find(existing_card.id)

    expect(card_in_original_list.exit_date).to    eq (Date.parse(action['date']))
    expect(card_in_original_list.time_in_list).to eq ((card_in_original_list.exit_date - card_in_original_list.entry_date).to_i)

    expect(card_in_new_list.list_id).to eq(action['data']['listAfter']['id'])
  end

  it "should enter a list on update if existing is not found" do
    action = JSON.parse(move_list_json)['action']
    card_in_new_list = subject.move_card_to_new_list(action)
    expect(card_in_new_list.list_id).to eq(action['data']['listAfter']['id'])
  end

  it "should exit a list when card is archived" do
    action = JSON.parse(archived_json)['action']
    existing_card         = FactoryGirl.create(:entry_only_card, card_id: action['data']['card']['id'])
    subject.archive_card(action)
    card_in_original_list = CardActivity.find(existing_card.id)
    expect(card_in_original_list.exit_date).to eq (Date.parse(action['date']))
  end

  it "should exit a list when card is deleted" do
    action = JSON.parse(deleted_json)['action']
    existing_card         = FactoryGirl.create(:entry_only_card,
                                                card_id: action['data']['card']['id'],
                                                list_id: action['data']['list']['id']
                                              )
    subject.delete_card(action)
    card_in_original_list = CardActivity.find(existing_card.id)
    expect(card_in_original_list.exit_date).to eq (Date.parse(action['date']))
  end

  it "should belong to a list" do
    list = FactoryGirl.create(:todo_list)
    card_activity = FactoryGirl.create(:entry_only_card)
    expect(card_activity.list.trello_list_id).to eq(list.trello_list_id)
  end
end
