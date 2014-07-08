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
	   @varianttitle=params[:vtitle]
	   @oid=params[:oid1]
	   @oid2=params[:oid2]
	   @oid3=params[:oid3]
	   @oidf=params[:vid]
	   @oidf=@oidf.to_s() +'-'
	   if params.has_key?(:oid1) && params.has_key?(:oid2)
	     @oidf=@oidf.to_s()
		 @oidf=@oidf+@oid+'-'
		 @oidf=@oidf.concat(@oid2.to_s)
		 @case="case12"
		 if params.has_key?(:oid3)
			@oidf=@oidf.to_s() +'-'
			@oidf=@oidf.concat(@oid3.to_s)
			@case="case123"
		 end
	   elsif params.has_key?(:oid1) && !params.has_key?(:oid2) && !params.has_key?(:oid3)
		@oid=@oid.gsub(/[" "]/, '-')
		@oidf=@oidf.concat(@oid.to_s)	
		@case="case1"
	   else
	     if params.has_key?(:oid1) && params.has_key?(:oid2)
			@oidf=@oid
			@case="case1"
			if params.has_key?(:oid3)
			@oidf=@oidf.to_s() +'-'
			@oidf=@oidf.concat(@oid3.to_s)
			@case="case13"
			end
		 elsif params[:oid1].empty? && params.has_key?(:oid2)
			@oidf=@oid2
			@case="case2"
			if params.has_key?(:oid3)
			@oidf=@oidf.to_s() +'-'
			@oidf=@oidf.concat(@oid3.to_s)
			@case="case23"
			end
		 end
		 
	   end

	  

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
	 # respond_to do |format|
    if(@product1)
        uploaded_image = params[:product][:product_image]
        @product1.images << ShopifyAPI::Image.new({:attachment =>
Base64.encode64(uploaded_image.read), :filename =>@oidf+".png",:metafield =>{:key => "alt",:value=>"ruchi",:value_type=>"string",:namespace => "tags"}})
@product1.save
#format.html { redirect_to :action => 'product', :id => @product1.id }
		#product.update_attributes(params[:product])
        flash[:notice] = "Successfully updated!"
       
    end
	#end
	  end
	  
	  def product
	@token= "#{shop_session.url}"
	@token=  @token.gsub("www","")
	 unless params[:id].blank?
      session[:product_id] = params[:id]
    end
	unless session[:product_id].blank?
      @product = ShopifyAPI::Product.find(session[:product_id])
	  @metafields=ShopifyAPI::Metafield.find(:first,:params=>{:resource => "products", :resource_id => session[:product_id], :key => "jt_swatch_show"})
	end
  end
  
	def destroy
	 respond_to do |format|
	@product=ShopifyAPI::Product.find(params[:id])
	img=params[:imgid]
	pid=params[:id]
	image = ShopifyAPI::Image.find(params[:imgid], :params => {:product_id => params[:id]})
	#image=ShopifyAPI::Image.find(1, :params => {:product_id => @pid})
	#image = ShopifyAPI::Image.find(params[:imgid], params[:id])
	image.destroy
	format.html { redirect_to :action => 'product', :id => @product.id }

	end
	end
	
	def destroyC
	respond_to do |format|
	vtid=params[:vtitle]
	pid=params[:pid]
	@vtitle=pid.to_s() +'-'
	@vtitle=@vtitle.concat(vtid.to_s)
	Cloudinary::Uploader.destroy(@vtitle, :invalidate => true)
	format.html { redirect_to :action => 'product', :id => pid }
	end

	end
	
	def check
	@pid=params[:product_id]
	@check=params[:check]
	respond_to do |format|
	if @check
	@product = ShopifyAPI::Shop.find(params[:product_id])
	  @meta= @product.add_metafield(ShopifyAPI::Metafield.new({
:description => 'show variant images on click',
:namespace => 'jt_swatch',
:key => 'jt_swatch_show',
:value => 'true',
:value_type => 'string'
}))
	else
	@product = ShopifyAPI::Shop.find(params[:product_id])
	@meta= @product.add_metafield(ShopifyAPI::Metafield.new({
:description => 'show variant images on click',
:namespace => 'jt_swatch',
:key => 'jt_swatch_show',
:value => 'false',
:value_type => 'string'
}))
	end
	format.html { redirect_to :action => 'product', :id => params[:product_id] }
	end
	end
	
	def color
	respond_to do |format|
	   @selectedColor=params[:car][:color]
	   @selectedColor=@selectedColor.gsub(/#/, "")
	   @select= "http://placehold.it/50x35/#{@selectedColor}/ffffff&text=+"
	   @p=params[:pid]
	   @variant=params[:vid]
	   @p=@p.to_s() +'-'
	@p.concat(@variant.to_s)
	   #@product = ShopifyAPI::Product.find(params[:product_id])
	   Cloudinary::Uploader.upload(@select,:public_id =>@p)
	   format.html { redirect_to :action => 'product', :id => params[:pid] }

	end
	end
  end