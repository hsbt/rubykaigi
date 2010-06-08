# coding: utf-8
class PagesController < LocaleBaseController
  skip_before_filter :login_required
  before_filter :readonly
  before_filter :page_name_is_valid
  before_filter :redirect_to_past_kaigi
#  before_filter :sponsors_only

  layout_for_latest_ruby_kaigi

  def show
    case params[:year]
    when "2009"
      render :file => "public/#{params[:year]}/#{params[:locale]}/index.html"
      return
    when "2010"
      @headlines = HeadlineEntry.recent(I18n.locale, 5)
      page = params[:page_name].blank? ? 'index' : params[:page_name]
      respond_to do |f|
        f.html { render :template => File.join('pages', params[:year], page) }
      end
      return
    end

    # params[:page_name] pass white list at `page_name_is_valid'
    begin
      render :template => "ruby_kaigi2009/#{params[:page_name]}_#{I18n.locale}"
    rescue Errno::ENOENT, ActionView::MissingTemplate => e
      alternative = Dir.glob(Rails.root + "app/views/ruby_kaigi2009/#{params[:page_name]}*").first
      if File.exist? alternative
        alt_locale = alternative.split("_").last.split(".").first
        redirect_to(:action => :show, :year => params[:year], :page_name => params[:page_name], :locale => alt_locale)
      else
        raise e
      end
    end
  end

  private
  def readonly
    raise MethodNotAllowd unless request.get? # FIXME: typo
  end

  def page_name_is_valid
    head(:not_found) unless /\A[A-Za-z_\-]*\Z/ =~ params[:page_name]
  end

  def redirect_to_past_kaigi
    if (year = params[:year].to_i) < 2009
      redirect_to "http://jp.rubyist.net/RubyKaigi#{year}"
    elsif 2010 < year
      render :file => "public/404.html"
    else
      true
    end
  end

  def sponsors_only
    return basic_auth_required_by_sponsor if params[:page_name] == "Sponsors"
    true
  end
end
