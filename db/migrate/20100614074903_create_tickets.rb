class CreateTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      t.string :ticket_code, :null => false, :unique => true
      t.string :ticket_type, :null => false
      t.string :code4url, :null => false, :unique => true
      t.string :name, :null => false
      t.string :email, :null => false
      t.references :contribution
      t.references :rubyist
      t.references :ruby_kaigi, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :tickets
  end
end
