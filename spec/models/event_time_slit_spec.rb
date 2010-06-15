require 'spec_helper'

describe EventTimeSlit do
  before(:each) do
    @valid_attributes = {
      :event_id => 1,
      :time_slit_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    EventTimeSlit.create!(@valid_attributes)
  end
end
