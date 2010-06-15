require 'spec_helper'

describe Ticket do
  describe "#build_from_contrib" do
    context "individual_sponsor" do
      before do
        @rubyist = Rubyist.make
        contrib = Contribution.make(
          :rubyist => @rubyist,
          :contribution_type => Contribution::Type.individual_sponsor
          )
        @tickets = Ticket.build_from_contrib(contrib)
        @tickets.map(&:save!)
      end

      subject { @tickets.first }

      its(:ticket_type) { should == "individual_sponsor" }

      specify "rubyist should have 1 ticket" do
        @rubyist.should have(1).tickets
      end

      context "n attendee" do
        before do
          @rubyist = Rubyist.make
          contribs = (1..3).to_a.map do |_|
            Contribution.make(
              :rubyist => @rubyist,
              :contribution_type => Contribution::Type.attendee
              )
          end
          @tickets = Ticket.build_from_contrib(contribs)
          @tickets.map(&:save!)
        end
        specify "3 ticket built" do
          @tickets.should have(3).items
        end

        specify "rubyist should have 3 ticket" do
          @rubyist.should have(3).tickets
        end
      end
    end
  end
end
