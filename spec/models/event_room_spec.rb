require 'spec_helper'

describe EventRoom do
  before(:each) do
    @valid_attributes = {
      :event_id => 1,
      :room_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    EventRoom.create!(@valid_attributes)
  end
end
