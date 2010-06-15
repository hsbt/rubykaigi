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
    if stock < 20
      content_tag :span, :style => 'background:#d5d536;border:1px solid #999;padding: 4px;margin-left:1em' do
        I18n.t('running_out_of_stock')
      end
    else
      content_tag :span, :style => 'background:#36d536;border:1px solid #999;padding: 4px;margin-left:1em' do
        I18n.t('in_stock')
      end
    end
  end
end
