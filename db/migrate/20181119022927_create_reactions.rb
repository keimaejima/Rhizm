class CreateReactions < ActiveRecord::Migration[5.2]
  def change
    create_table :reactions do |t|
      t.string :user_id
      t.string :reaction
      t.string :item_user_id
      t.string :channel_id

      t.timestamps
    end
  end
end
