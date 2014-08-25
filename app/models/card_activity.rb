class CardActivity < ActiveRecord::Base
  belongs_to :board, primary_key: :trello_board_id, foreign_key: :board_id
  belongs_to :list, primary_key: :trello_list_id, foreign_key: :list_id

  def self.create_entry(action)
    entry_date = Date.parse(action['date'])
    Board.find_or_create_by(
      trello_board_id: action['data']['board']['id'],
      name: action['data']['board']['name']
    )
    List.find_or_create_by(
      trello_list_id: action['data']['list']['id'],
      name: action['data']['list']['name'],
      trello_board_id: action['data']['board']['id']
    )
    card_activity = CardActivity.create({
      card_id: action['data']['card']['id'],
      list_id: action['data']['list']['id'],
      board_id: action['data']['board']['id'],
      entry_date: entry_date,
      grouping_year: entry_date.year,
      grouping_month: entry_date.mon,
      grouping_week: entry_date.cweek
    })
    card_activity
  end

  def self.move_card_to_new_list(action)
    Board.find_or_create_by(
      trello_board_id: action['data']['board']['id'],
      name: action['data']['board']['name']
    )
    List.find_or_create_by(
      trello_list_id: action['data']['listBefore']['id'],
      name: action['data']['listBefore']['name'],
      trello_board_id: action['data']['board']['id']
    )
    List.find_or_create_by(
      trello_list_id: action['data']['listAfter']['id'],
      name: action['data']['listAfter']['name'],
      trello_board_id: action['data']['board']['id']
    )
    list_id = action['data']['listBefore']['id']
    card_id = action['data']['card']['id']
    matches = CardActivity.where(list_id: list_id, card_id: card_id, exit_date: nil).order(entry_date: :desc)

    action_date = Date.parse(action['date'])
    unless matches.empty?
      original = matches.first
      original.exit_date = action_date
      original.time_in_list = (original.exit_date - original.entry_date).to_i
      original.save
    end

    card_in_new_list = CardActivity.create({
      card_id: action['data']['card']['id'],
      list_id: action['data']['listAfter']['id'],
      board_id: action['data']['board']['id'],
      entry_date: action_date,
      grouping_year: action_date.year,
      grouping_month: action_date.mon,
      grouping_week: action_date.cweek
    })
    card_in_new_list
  end

end
