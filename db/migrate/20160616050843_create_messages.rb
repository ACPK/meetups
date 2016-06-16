class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages, id: :uuid do |t|
      t.string :content
      t.uuid :user_id
      t.uuid :meetup_id

      t.timestamps
    end
    add_index :messages, :user_id
    add_index :messages, :meetup_id
  end
end
