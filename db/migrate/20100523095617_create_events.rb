class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :title_en
      t.string :title_ja
      t.text :abstract_en
      t.text :abstract_ja
      t.string :detail_en
      t.string :detail_ja
      t.string :additional_info
      t.string :lang
      t.string :required_equipment
      t.integer :parent_event_id
      t.boolean :break

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
