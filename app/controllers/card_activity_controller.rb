class CardActivityController < ApplicationController
  def create
    unless request.headers.include?('HTTP_X_TRELLO_WEBHOOK')
      render_unauthorized
      return
    else
      post_data = JSON.parse(request.raw_post)
      action = post_data['action']
      unless authorized_boards.include?(action['data']['board']['id'])
        render_unauthorized
        return
      end
      mode = determine_mode(action)
      create_entry(action) if mode == :create
      update_entry(action) if mode == :move
    end

  end

  private

  def render_unauthorized
      render text: 'You do not have permission.', status: :unauthorized
  end

  def authorized_boards
    Subscription.where(active: true).pluck(:model_id)
  end

  def determine_mode(action)
    mode = nil
    mode = :create if action['type'] == 'createCard'
    mode = :move   if action['type'] == 'updateCard' &&
      action['data']['listAfter']['id'] &&
      action['data']['listBefore']['id']
    mode
  end

  def create_entry(action)
    CardActivity.create_entry(action)
  end

  def update_entry(action)
    CardActivity.move_card_to_new_list(action)
  end
end
