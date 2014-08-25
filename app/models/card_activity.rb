class CardActivity < ActiveRecord::Base
  belongs_to :board, primary_key: :trello_board_id, foreign_key: :board_id
  belongs_to :list, primary_key: :trello_list_id, foreign_key: :list_id

  def self.create_entry(action)
    entry_date = Date.parse(action['date'])
    ensure_board(action['data']['board']['id'], action['data']['board']['name'])
    ensure_list(action['data']['list']['id'], action['data']['list']['name'], action['data']['board']['id'])

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
    ensure_board(action['data']['board']['id'], action['data']['board']['name'])
    ensure_list(action['data']['listBefore']['id'], action['data']['listBefore']['name'], action['data']['board']['id'])
    ensure_list(action['data']['listAfter']['id'], action['data']['listAfter']['name'], action['data']['board']['id'])

    list_id = action['data']['listBefore']['id']
    card_id = action['data']['card']['id']
    matches = CardActivity.where(list_id: list_id, card_id: card_id, exit_date: nil).order(entry_date: :desc)

    action_date = Date.parse(action['date'])
    set_exit_date_and_time_in_list(matches, action_date)

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

  def self.archive_card(action)
    ensure_board(action['data']['board']['id'], action['data']['board']['name'])
    matches = CardActivity.where(card_id: action['data']['card']['id'], exit_date: nil).order(entry_date: :desc)
    set_exit_date_and_time_in_list(matches, Date.parse(action['date']))
  end

  def self.delete_card(action)
    ensure_board(action['data']['board']['id'], action['data']['board']['name'])
    list_id = action['data']['list']['id']
    card_id = action['data']['card']['id']
    matches = CardActivity.where(list_id: list_id, card_id: card_id, exit_date: nil).order(entry_date: :desc)
    set_exit_date_and_time_in_list(matches, Date.parse(action['date']))
  end

  private

  def self.ensure_board(id, name)
    Board.find_or_create_by(
      trello_board_id: id,
      name: name
    )
  end

  def self.ensure_list(list_id, list_name, board_id)
    List.find_or_create_by(
      trello_list_id: list_id,
      name: list_name,
      trello_board_id: board_id
    )
  end

  def self.set_exit_date_and_time_in_list(matches, action_date)
    unless matches.empty?
      original = matches.first
      original.exit_date = action_date
      original.time_in_list = (original.exit_date - original.entry_date).to_i
      original.save
    end
  end

end
