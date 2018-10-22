class CreateTemporaryTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :temporary_tokens do |t|
      t.integer :temporary_token_id
      t.integer :user_id
      t.integer :token_amount

      t.timestamps
    end
  end
end
