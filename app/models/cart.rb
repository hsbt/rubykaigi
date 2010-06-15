# -*- coding: utf-8 -*-
class Cart
  class OverProductItemLimitationError < StandardError;  end
  attr_reader :items

  def initialize
    @items = []
  end

  def add_product(product, qty = nil)
    current_item = @items.find {|item| item.product_item == product }
    if current_item
      if qty == 0
        remove_product(product)
#      else
#        current_item.increment_quantity(qty) unless product.individual_sponsor?
      end
    else
      current_item = CartItem.new(product)
      @items << current_item
    end
    current_item
  end

  def remove_product(product)
    current_item = @items.find {|item| item.product_item == product }
    if current_item
      @items.delete(current_item)
    end
    current_item
  end

  def total_price
    @items.sum { |item| item.subtotal_price }
  end

  def total_items
    @items.sum { |item| item.quantity }
  end

  def empty?
    !!@items.empty?
  end

  def individual_sponsor
    @items.detect {|item| item.individual_sponsor? }
  end
end
