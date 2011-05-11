class ApplicationController < ActionController::Base
  protect_from_forgery
  
  private
  def current_cart
    Cart.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
        cart = Cart.create
        session[:cart_id] = cart
        cart
  end
  
  def reset_counter
      session[:counter] = 1
  end
end
