# -*- coding: utf-8 -*-
class Order < ActiveRecord::Base
  belongs_to :rubyist
  belongs_to :ruby_kaigi
  has_many :line_items, :class_name => OrderItem.name

  belongs_to :paypal_payment_notification, :class_name => Paypal::PaymentNotification.name

  class << self
    def generate_invoice_code
      ymd = Date.today.to_s(:db).gsub(/-/,'')
      prefix = Digest::SHA1.hexdigest(srand.to_s)[0..7].upcase
      "#{ymd}-#{prefix}"
    end
  end # engenclass

  def before_create
    self.invoice_code = Order.generate_invoice_code
  end

  def before_save
    calculate_price
  end

  def add_line_item_from_cart(cart)
    cart.items.each do |item|
      li = OrderItem.from_cart_item(item)
      line_items << li
    end
  end

  def calculate_price
    self.price = line_items.inject(0){|r,sum| r += sum.subtotal_price}
  end

  def individual_sponsor_included?
    line_items.detect {|item| item.individual_sponsor? }
  end

  def completed?
    paypal_payment_notification.present? && paypal_payment_notification.completed?
  end
end
