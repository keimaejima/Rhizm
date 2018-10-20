class CreateStableTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :stable_tokens do |t|
      t.integer :stable_token_id
      t.integer :user_id
      t.integer :token_amount

      t.timestamps
    end
  end
end
