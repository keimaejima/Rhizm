class CreateTokenAmountMasters < ActiveRecord::Migration[5.2]
  def change
    create_table :token_amount_masters do |t|
      t.integer :token_amount_master_id
      t.integer :token_amount

      t.timestamps
    end
  end
end
