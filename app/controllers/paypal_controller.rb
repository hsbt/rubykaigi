# -*- coding: utf-8 -*-
class PaypalController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:instant_payment_notification]

  verify :method => :post, :only => [:instant_payment_notification]
  def instant_payment_notification
    logger.info("==== ipn params ====>")
    logger.info("{")
    notified_params = params.dup
    notified_params.to_a.sort_by{|pair| pair.first}.each do |(k,v)|
      logger.info("'#{k}' => '#{v}',")
    end
    logger.info("}")
    logger.info("<==== ipn params ====>")

    unless (params[:secret] == Paypal::EncryptedForm.ipn_secret ||
        params[:receiver_email] == Paypal::EncryptedForm.business_email)
      render :nothing => true, :status => 400
      return
    end

    unless (order = Order.find_by_invoice_code(params["invoice"]))
      render :nothing => true, :status => 404
      return
    end

# FIXME Order#priceのバグのため、個人スポンサー販売時にはこの数値が合ってなかった。削るか復活させるかはもうちょっとテストを書けるかどうかで判断したいので、いまはコメントアウトしてる(kakutani)
#    unless (params[:mc_gross] == order.price.to_s && params[:mc_currency] == "JPY")
#      render :nothing => true, :status => 400
#      return
#    end

    Order.transaction do
      notification = Paypal::PaymentNotification.from_notified_params(params)
      order.paypal_payment_notification = notification
      notification.save!
      order.save!
    end

    Delayed::Job.enqueue(Paypal::HandlePaymentNotificationJob.new(order.id))
    render :nothing => true, :status => 200
  end
end
