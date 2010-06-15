require 'spec_helper'

describe Room do
  before(:each) do
    @valid_attributes = {
      :name_en => "value for name_en",
      :name_ja => "value for name_ja",
      :floor_en => "value for floor_en",
      :floor_ja => "value for floor_ja",
      :sort_order => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Room.create!(@valid_attributes)
  end
end
