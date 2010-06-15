class CreateTimeSlits < ActiveRecord::Migration
  def self.up
    create_table :time_slits do |t|
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps
    end
  end

  def self.down
    drop_table :time_slits
  end
end
