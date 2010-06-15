require 'spec_helper'

describe EventsController do
  describe 'GET index' do
    it 'assigns all events as @events' do
      events = [event = Event.make]
      mock(Event).all.with_any_args { events }
      get :index
      assigns[:events].should == events
      assigns[:rooms].should == [event.room]
    end
  end
end
