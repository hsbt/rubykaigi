class CreateEventRooms < ActiveRecord::Migration
  def self.up
    create_table :event_rooms do |t|
      t.references :event
      t.references :room

      t.timestamps
    end
  end

  def self.down
    drop_table :event_rooms
  end
end
