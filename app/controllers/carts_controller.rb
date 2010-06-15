# -*- coding: utf-8 -*-
class CartsController < ApplicationController
  layout_for_latest_ruby_kaigi
  before_filter :login_required, :only => :index

  def index
    @cart = current_cart
  end

  def add_item
    @cart = current_cart
    product_item = ProductItem.find_by_item_code(params[:product_item_code])
    unless product_item
      flash[:error] = "ProductItem error"
      redirect_to(registrations_url(:year => RubyKaigi.latest_year, :locale => current_locale)) and return
    end
    if product_item.individual_sponsor? && authenticated? && user.individual_sponsor?
      flash[:error] = "You're already Individual Sponsor of RubyKaigi #{RubyKaigi.latest_year}"
      redirect_to(registrations_url(:year => RubyKaigi.latest_year, :locale => current_locale)) and return
    end

    begin
      @cart.add_product(product_item)
    rescue Cart::OverProductItemLimitationError
      flash[:error] = "You cannot register such quantity at once(you should set under 4 or we don't have enough stock)."
      redirect_to(carts_path) and return
    end

    redirect_to carts_path
  end

  def update
    @cart = current_cart
    new_qty = params[:qty].map {|item_code, qty| [item_code, qty.to_i]}
    new_qty.each do |(item_code, qty)|
      product_item = ProductItem.find_by_item_code(item_code)
      unless product_item
        flash[:error] = "ProductItem error"
        redirect_to(carts_path) and return
      end
      if product_item.individual_sponsor? && authenticated? && user.individual_sponsor?
        flash[:error] = "You cannot change qty for Individual Sponsor of RubyKaigi #{RubyKaigi.latest_year}"
        redirect_to(registrations_url(:year => RubyKaigi.latest_year, :locale => current_locale)) and return
      end
      begin
        @cart.add_product(product_item, qty)
      rescue Cart::OverProductItemLimitationError
        flash[:error] = "You cannot register such quantity at once(you should set under 4 or we don't have enough stock)."
        redirect_to(carts_path) and return
      end

    end
    redirect_to carts_path
  end

  def remove_item
    cart = current_cart
    product_item = ProductItem.find_by_item_code(params[:product_item_code])
    cart.remove_product(product_item)
    redirect_to carts_path
  end

end
