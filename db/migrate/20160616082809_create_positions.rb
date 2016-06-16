class CreatePositions < ActiveRecord::Migration[5.0]
  def change
    create_table :positions, id: :uuid do |t|
      t.integer :position_type
      t.float :latitude
      t.float :longitude
      t.uuid :user_id

      t.timestamps
    end
    add_index :positions, :user_id
  end
end
