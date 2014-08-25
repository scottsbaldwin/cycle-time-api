class List < ActiveRecord::Base
  belongs_to :board, primary_key: :trello_board_id, foreign_key: :trello_board_id
  has_many :card_activity, primary_key: :trello_list_id, foreign_key: :list_id
  validates :trello_list_id, uniqueness: true
end
