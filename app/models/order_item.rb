# -*- coding: utf-8 -*-
class OrderItem < ActiveRecord::Base
  belongs_to :product_item
  belongs_to :order

  has_one :individual_sponsor_option

  class << self
    def from_cart_item(cart_item)
      li = new
      li.product_item = cart_item.product_item
      li.quantity = cart_item.quantity
      li.unit_price = cart_item.unit_price
      if cart_item.individual_sponsor?
        li.build_individual_sponsor_option
      end
      li
    end
  end

  def price
    unit_price + additional_amount.to_i
  end

  def item_code
    product_item.item_code
  end

  def subtotal_price
    price * quantity
  end

  def individual_sponsor?
    product_item.individual_sponsor?
  end

  [:link_label, :link_url, :additional_amount, :attend_party?, :anonymous?].each do |sym|
    define_method(sym) { individual_sponsor_option.try(sym) }
  end
end
