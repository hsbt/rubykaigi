class CreateRooms < ActiveRecord::Migration
  def self.up
    create_table :rooms do |t|
      t.string :name_en
      t.string :name_ja
      t.string :floor_en
      t.string :floor_ja
      t.integer :sort_order

      t.timestamps
    end
  end

  def self.down
    drop_table :rooms
  end
end
