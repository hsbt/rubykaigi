require 'spec_helper'

describe Event do
  before(:each) do
    @valid_attributes = {
      :title_en => "value for title_en",
      :title_ja => "value for title_ja",
      :abstract_en => "value for abstract_en",
      :abstract_ja => "value for abstract_ja",
      :detail_en => "value for detail_en",
      :detail_ja => "value for detail_ja",
      :additional_info => "value for additional_info",
      :lang => "value for lang",
      :required_equipment => "value for required_equipment",
      :parent_event_id => 1,
      :break => false
    }
  end

  it "should create a new instance given valid attributes" do
    Event.create!(@valid_attributes)
  end
end
