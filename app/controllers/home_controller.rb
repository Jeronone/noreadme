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
  uploaded_io = params[:datafile]
  puts YAML::dump(params[:datafile])
  File.open(Rails.root.join('public', 'bin', uploaded_io.original_filename), 'wb') do |file|
  file.write(uploaded_io.read)
  end
  end
  
end