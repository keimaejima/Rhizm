class CreatePlans < ActiveRecord::Migration[5.2]
  def change
    create_table :plans do |t|
      t.string :stripe_plan_id
      t.string :name
      t.integer :amount
      t.string :currency
      t.string :interval
      t.string :statement_descriptor
      t.timestamps
    end
  end
end
