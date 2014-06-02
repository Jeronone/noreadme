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
    #@orders   = ShopifyAPI::Order.find(:all, :params => {:limit => 5, :order => "created_at DESC" })
  end
  def upload
  
  
      @product1 = ShopifyAPI::Product.find(params[:id])
	   variantid=params[:vid]
	   varianttitle=params[:vtitle]
	  # code to check if the image already exist or not
	  # if yes then delete the existing one 
	 
	 # @arr = @product.images
	 
	 # puts YAML::dump(variantid)
	 # puts YAML::dump(varianttitle)
	  #if(@product)
	   #uploaded_image = params[:product][:product_image]
	  #a = ShopifyAPI::Image.new
      #a.prefix_options = {:product_id => params[:id]}
      #a.metafields = [{:key => 'alt', :value => varianttitle, :value_type => "string", :namespace =>  "tags"}]
      #a.attachment = Base64.encode64(uploaded_image.read)
      #a.filename = varianttitle+"-"+variantid+".png"
      #a.save
    if(@product1)
        uploaded_image = params[:product][:product_image]
        @product1.images << ShopifyAPI::Image.new({:attachment =>
Base64.encode64(uploaded_image.read), :filename => varianttitle+"-"+variantid+".png",:metafield =>{:key => "alt",:value=>"ruchi",:value_type=>"string",:namespace => "tags"}})
 @product1.save
		#product.update_attributes(params[:product])
        flash[:notice] = "Successfully updated!"
       
    end
	  end
	  
	  def product
	@token= "#{shop_session.url}"
	@token=  @token.gsub("www","")
	 unless params[:id].blank?
      session[:product_id] = params[:id]
    end
	unless session[:product_id].blank?
      @product = ShopifyAPI::Product.find(session[:product_id])
	  @metafields=ShopifyAPI::Metafield.find(:first,:params=>{:resource => "products", :resource_id => session[:product_id], :key => "alt"})
	end
  end
  
	def destroy
	@product=ShopifyAPI::Product.find(params[:id])
	@img=params[:imgid]
	image = ShopifyAPI::Image.find(params[:imgid])
	image.destroy
	end
  
end