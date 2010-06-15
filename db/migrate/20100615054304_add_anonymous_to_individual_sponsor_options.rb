class AddAnonymousToIndividualSponsorOptions < ActiveRecord::Migration
  def self.up
    add_column :individual_sponsor_options, :anonymous, :boolean, :default => false
  end

  def self.down
    remove_column :individual_sponsor_options, :anonymous
  end
end
