class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.string :slack_id
      t.text :text
      t.string :channel_id
      t.string :team_id

      t.timestamps
    end
  end
end
