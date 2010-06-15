class TicketsController < ApplicationController
  before_filter :login_required, :except => [:show, :regenerate_permalink]

  layout_for_latest_ruby_kaigi

  def index
    @tickets = user.tickets_of(RubyKaigi.latest_year)
  end

  def edit
    @ticket = Ticket.find_by_code4url(params[:id])
    unless @ticket.rubyist == user
      render :status => '403', :file => 'public/403.html'
      return
    end
    unless @ticket
      render :status => '404', :file => 'public/404.html'
      return
    end
    @title = "[Edit] #{@ticket.ticket_code}, #{I18n.t(@ticket.ticket_type)}"
  end

  def update
    @ticket = Ticket.find_by_code4url(params[:id])
    unless @ticket.rubyist == user
      render :status => '403', :file => 'public/403.html'
      return
    end
    unless @ticket
      render :status => '404', :file => 'public/404.html'
      return
    end
    @ticket.name = params[:ticket][:name]
    @ticket.email = params[:ticket][:email]
    if @ticket.save
      flash[:notice] = 'Your ticket have been updated.'
      redirect_to ticket_path(@ticket)
    else
      render :edit
    end
  end

  def show
    @ticket = Ticket.find_by_code4url(params[:id])
    unless @ticket
      render :status => '404', :file => 'public/404.html'
      return
    end
    @title = "#{@ticket.ticket_code}, #{I18n.t(@ticket.ticket_type)}"
  end

  def regenerate_permalink
    @ticket = Ticket.find_by_code4url(params[:id])
    unless @ticket
      render :status => '404', :file => 'public/404.html'
    end
    @ticket.update_attribute(:code4url, Ticket.generate_code4url)
    redirect_to ticket_path(@ticket)
  end
end
