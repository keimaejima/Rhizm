class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.integer :slack_id
      t.text :text
      t.integer :channel_id
      t.integer :team_id

      t.timestamps
    end
  end
end
