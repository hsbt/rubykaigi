class Ticket < ActiveRecord::Base
  belongs_to :contribution
  belongs_to :ruby_kaigi
  belongs_to :rubyist

  validates_presence_of :name

  class << self
    def generate_ticket_code
      prefix = Digest::SHA1.hexdigest(srand.to_s)[0..7].upcase
      suffix = Digest::SHA1.hexdigest(srand.to_s)[0..7].upcase
      "#{prefix}-#{suffix}"
    end

    def generate_code4url
      Digest::SHA1.hexdigest(srand.to_s)[0..31]
    end

    def build_from_contrib(*contrib)
      contribs = contrib.flatten
      contribs.map do |c|
        Ticket.new(
          :ticket_code => Ticket.generate_ticket_code,
          :ticket_type => c.contribution_type,
          :code4url => Ticket.generate_code4url,
          :name => c.name_for_ticket,
          :email => c.email_for_ticket,
          :contribution => c,
          :rubyist => c.rubyist,
          :ruby_kaigi => c.ruby_kaigi
          )
      end
    end
  end # eigenclass

  def to_param
    code4url
  end

  def before_save
    self.email = "N / A" if self.email.blank?
  end
end
