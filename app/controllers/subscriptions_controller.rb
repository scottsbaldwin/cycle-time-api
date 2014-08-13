require 'trello'

class SubscriptionsController < ApplicationController
  def index
    @subscriptions = Subscription.order(:description)
    render json: @subscriptions
  end

  def create
    unless params['subscription']
      render text: 'Missing "subscription" root element in request body.', status: :bad_request
    else
      @sub = Subscription.new(subscription_params)
      begin
        hook = Trello::Webhook.create(
          id_model: @sub.model_id,
          description: @sub.description,
          callback_url: @sub.callback_url
        )
        @sub.webhook_id = hook.id
        @sub.active = hook.active
        if (@sub.save)
          render json: @sub
        else
          render json: @sub.errors.messages.to_json, status: :bad_request
        end
      rescue Trello::Error => e
        render json: {error: "Couldn't create Trello Webhook: #{e.to_s.chomp}"}.to_json, status: :bad_request
      rescue StandardError => e
        render json: {error: "Couldn't create Trello Webhook: #{e.to_s.chomp}"}.to_json, status: :internal_server_error
      end
    end
  end

  def destroy
    @sub = Subscription.find(params[:id])
    begin
      hook = Trello::Webhook.find(@sub.webhook_id)
      hook.delete
      @sub.destroy
      render nothing: true, status: :no_content
    rescue Trello::Error => e
        render json: {error: "Couldn't create Trello Webhook: #{e.to_s.chomp}"}.to_json, status: :bad_request
    end
  end

  private
  def subscription_params
    params.require(:subscription).permit(:model_id, :description, :callback_url)
  end
end
