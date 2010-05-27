class Rubyist < ActiveRecord::Base
  extend  ActiveSupport::Memoizable

  has_many :contributions

  validates_uniqueness_of :username
  validates_format_of :username, :with => /^[\w-]+$/
  validates_exclusion_of :username, :in => %w(new edit)

  validates_format_of :website, :with => URI.regexp(%w(http https)), :allow_blank => true

  validates_uniqueness_of :twitter_user_id, :allow_nil => true
  validates_uniqueness_of :identity_url, :allow_nil => true

  validates_inclusion_of :avatar_type, :in => %w(default twitter gravatar)

  attr_protected :twitter_user_id, :identity_url

  def to_param
    username
  end

  def individual_sponsor(kaigi_year = RubyKaigi.latest_year)
    contrib = contributions_on(kaigi_year).detect{ |c|
      c.contribution_type =~ /individual_sponsor/
    }
    contrib.as_individual_sponsor
  end

  def contributions_on(kaigi_year = RubyKaigi.latest_year)
    contributions.select{|c| c.ruby_kaigi.year == kaigi_year}
  end

  def individual_sponsor?(kaigi_year = RubyKaigi.latest_year)
    contribution_types_of(kaigi_year).include?('individual_sponsor')
  end

  def attendee?(kaigi_year = RubyKaigi.latest_year)
    __attendee?(kaigi_year) || individual_sponsor?(kaigi_year)
  end

  def staff?(kaigi_year = RubyKaigi.latest_year)
    contribution_types_of(kaigi_year).include?(Contribution::Type.staff)
  end

  def ruby_committer?(kaigi_year = RubyKaigi.latest_year)
    true
  end

  def party_attendee?(kaigi_year = RubyKaigi.latest_year)
    contribution_types_of(kaigi_year).include?('party_attendee')
  end

  def twitter_account
    return nil if twitter_user_id.blank?
    @twitter_account ||= TwitterAccount.new(twitter_user_id)
  end

  def avatar_url(type = avatar_type)
    case type.to_s
    when 'twitter'
      twitter_account.try(:profile_image_url)
    when 'gravatar'
      "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.downcase)}?s=48"
    else
      # TODO 棒人間に差し替える
      '/2010/images/icon.gif'
    end
  end

  private
  def contribution_types_of(kaigi_year)
    contributions.select {|c| c.ruby_kaigi.year == kaigi_year }.map(&:contribution_type)
  end
  memoize :contribution_types_of

  def __attendee?(kaigi_year)
    contribution_types_of(kaigi_year).include?('attendee')
  end
end
