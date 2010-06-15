require 'spec_helper'

describe TimeSlit do
  before(:each) do
    @valid_attributes = {
      :start_at => Time.now,
      :end_at => Time.now
    }
  end

  it "should create a new instance given valid attributes" do
    TimeSlit.create!(@valid_attributes)
  end
end
