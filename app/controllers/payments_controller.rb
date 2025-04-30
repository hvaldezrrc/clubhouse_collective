class PaymentsController < ApplicationController
  before_action :find_order, only: [ :create, :confirm ]

  def create
    begin
      amount_in_cents = (@order.total_amount * 100).to_i

      payment_intent = Stripe::PaymentIntent.create({
        amount: amount_in_cents,
        currency: "usd",
        metadata: { order_id: @order.id }
      })

      render json: { client_secret: payment_intent.client_secret }
    rescue Stripe::StripeError => e
      flash[:error] = e.message
      redirect_to checkout_path
    end
  end

  def confirm
    begin
      payment_intent = Stripe::PaymentIntent.retrieve(params[:payment_intent_id])

      if payment_intent.status == "succeeded"
        @order.update(status: "paid", payment_intent_id: payment_intent.id)
        flash[:success] = "Payment successfully completed!"
        redirect_to order_path(@order)
      else
        flash[:error] = "Payment failed. Please try again."
        redirect_to checkout_payment_path(@order)
      end
    rescue Stripe::StripeError => e
      flash[:error] = "Payment confirmation failed: #{e.message}"
      redirect_to checkout_payment_path(@order)
    end
  end

  private

  def find_order
    @order = Order.find(params[:order_id])
  end
end
