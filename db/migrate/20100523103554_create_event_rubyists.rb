class CreateEventRubyists < ActiveRecord::Migration
  def self.up
    create_table :event_rubyists do |t|
      t.references :event
      t.references :rubyist

      t.timestamps
    end
  end

  def self.down
    drop_table :event_rubyists
  end
end
