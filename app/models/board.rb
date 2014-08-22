class Board < ActiveRecord::Base
  has_many :lists, primary_key: :trello_board_id, foreign_key: :trello_board_id
  validates :trello_board_id, uniqueness: true
end
