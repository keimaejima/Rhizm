class AddChargeFlagToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :charge_flag, :bool
  end
end
