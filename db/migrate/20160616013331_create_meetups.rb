class CreateMeetups < ActiveRecord::Migration[5.0]
  def change
    create_table :meetups, id: :uuid do |t|
      t.string :topic

      t.timestamps
    end
  end
end
