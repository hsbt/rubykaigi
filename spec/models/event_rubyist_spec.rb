require 'spec_helper'

describe EventRubyist do
  before(:each) do
    @valid_attributes = {
      :event_id => 1,
      :rubyist_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    EventRubyist.create!(@valid_attributes)
  end
end
