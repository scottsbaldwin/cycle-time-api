class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string  :model_id
      t.string  :description
      t.string  :callback_url
      t.string  :webhook_id
      t.boolean :active
      t.timestamps
    end

    add_index :subscriptions, :model_id

  end
end
