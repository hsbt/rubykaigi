# -*- coding: utf-8 -*-
module RegistrationsHelper
  def img_add_to_cart_button
    file_path = "/2010/images/addtocart_#{current_locale}.png"
    alt = (current_locale == "ja" ? "カートへ入れる" : "Add To Cart")
    image_tag(file_path, :alt => alt)
  end

  def stock_notification(item)
    return "" unless item.now_on_sale?
    stock = item.stock
    if stock == 0
      content_tag :span, :style => 'background:#e7161c;border:1px solid #999;padding: 4px;margin-left:1em' do
        'Out of Stock'
      end
    elsif stock < 20
      content_tag :span, :style => 'background:#d5d536;border:1px solid #999;padding: 4px;margin-left:1em' do
        'Running Out of Stock'
      end
    else
      content_tag :span, :style => 'background:#36d536;border:1px solid #999;padding: 4px;margin-left:1em' do
        'In Stock'
      end
    end
  end
end
