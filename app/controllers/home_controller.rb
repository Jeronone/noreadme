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
  if @params[:image_id].present?
     preloaded = Cloudinary::PreloadedFile.new(params[:image_id])
     # Verify signature by calling preloaded.valid?
     @model.image_id = preloaded.identifier
	  flash[:notice] = "Successfully updated!"
  end
  
      #@product = ShopifyAPI::Product.find(params[:id])
	  # variantid=params[:vid]
	  # varianttitle=params[:vtitle]
	  # code to check if the image already exist or not
	  # if yes then delete the existing one 
	 
	 # @arr = @product.images
	 
	 # puts YAML::dump(variantid)
	 # puts YAML::dump(varianttitle)
    #if(@product)
      #  uploaded_image = params[:product][:product_image]
      #  @product.images << ShopifyAPI::Image.new({:attachment =>
#Base64.encode64(uploaded_image.read), :filename => varianttitle+"-"+variantid+".png"})
 #@product.save
		#product.update_attributes(params[:product])
        #flash[:notice] = "Successfully updated!"
       
    #end
	  end
  
end