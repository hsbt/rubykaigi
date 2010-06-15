class OrdersController < ApplicationController
  before_filter :login_required

  layout_for_latest_ruby_kaigi

  def create
    cart = current_cart
    unless cart.all_item_in_stock?
      flash[:error] = "Your cart is including out of stock item(s). Remove item(s) from your cart and retry."
      redirect_to(carts_path) and return
    end
    @order = Order.new(:rubyist => user, :ruby_kaigi => RubyKaigi.latest)
    @order.add_line_item_from_cart(cart)
    if @order.individual_sponsor_included? && authenticated? && user.individual_sponsor?
      flash[:error] = "You're already Individual Sponsor of RubyKaigi #{RubyKaigi.latest_year}"
      redirect_to(carts_path) and return
    end
    if @order.save
      session[:order_id] = @order.id
      if @order.individual_sponsor_included?
        redirect_to individual_sponsor_option_orders_path
      else
        redirect_to confirm_orders_path
      end
    else
      flash[:error] = t('flash.order.save.fail')
      redirect_to carts_path
    end
  end

  def confirm
    @order = Order.find(session[:order_id])
    @paypal_form = Paypal::EncryptedForm.new(@order,
      thanks_orders_url, paypal_ipn_url(:secret => Paypal::EncryptedForm.ipn_secret))
    unless @order
      flash[:error] = t('flash.order.notfound')
      redirect_to carts_path
    end
  end

  def update
    @order = Order.find(params[:id])
    if (opt_params = params[:individual_sponsor_option])
      if update_individual_sponsor_option(opt_params)
        session[:order_id] = @order.id
        redirect_to confirm_orders_path and return
      else
        render :individual_sponsor_option
      end
    end
  end

  # XXX Restfulにしたほうがいいよなーと思いつつも易きに流れます(kakutani)
  def individual_sponsor_option
    @order = Order.find(session[:order_id], :include => [:line_items => [:individual_sponsor_option]])
    @option = @order.line_items.detect {|i| i.individual_sponsor? }.individual_sponsor_option
    @option.link_url = user.website if @option.link_url.blank?
    @option.link_label = user.full_name if @option.link_label.blank?
  end

  def thanks
    clear_current_cart
  end

  private
  def clear_current_cart
    session[:cart] = nil
  end

  def update_individual_sponsor_option(opt_params)
    @option = IndividualSponsorOption.find(opt_params[:id])
    @option.additional_amount = opt_params[:additional_amount].to_i
    @option.attend_party = opt_params[:attend_party]
    @option.link_label = opt_params[:link_label]
    @option.link_url = opt_params[:link_url]
    @option.save
    order = @option.order_item.order
    order.calculate_price
    order.save
  end
end
