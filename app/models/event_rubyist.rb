class EventRubyist < ActiveRecord::Base
  belongs_to :event
  belongs_to :rubyist
end
