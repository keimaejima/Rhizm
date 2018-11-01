class CreatePresentTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :present_tokens do |t|
      t.integer :present_token_id
      t.integer :receive_user_id
      t.integer :present_user_id
      t.integer :token_amount

      t.timestamps
    end
  end
end
