class HomeController < ApplicationController
  
  around_filter :shopify_session, :except => 'welcome'
  
  def welcome
    current_host = "#{request.host}#{':' + request.port.to_s if request.port != 80}"
    @callback_url = "http://#{current_host}/login"
  end
  
  def index
    # get 10 products
    @products = ShopifyAPI::Product.find(:all, :params => {:limit => 10})

    # get latest 5 orders
    @orders   = ShopifyAPI::Order.find(:all, :params => {:limit => 5, :order => "created_at DESC" })
  end
  def upload
  def update_product
    product = Product.find(params[:id])
    if(product)
        uploaded_image = params[:product][:product_image].original_filename
        product.update_attributes(params[:product])
        flash[:notice] = "Successfully updated!"
       
    end
	end
  end
  
end