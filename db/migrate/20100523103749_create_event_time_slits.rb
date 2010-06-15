class CreateEventTimeSlits < ActiveRecord::Migration
  def self.up
    create_table :event_time_slits do |t|
      t.references :event
      t.references :time_slit

      t.timestamps
    end
  end

  def self.down
    drop_table :event_time_slits
  end
end
