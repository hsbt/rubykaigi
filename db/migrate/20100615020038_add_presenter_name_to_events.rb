class AddPresenterNameToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :presenter_name, :string
  end

  def self.down
    remove_column :events, :presenter_name
  end
end
