Spree::Admin::PricesController.class_eval do

    def index
      params[:q] ||= {}
      @product = Spree::Product.find_by(slug: params[:product_id])

      @search = @product.prices.accessible_by(current_ability, :index).ransack(params[:q])
      @master_prices = @search.result
        .currently_valid
        .for_master
        .order(:variant_id, :country_iso, :currency)
        .page(params[:page]).per(Spree::Config.admin_variants_per_page)
      @variant_prices = @search.result
        .currently_valid
        .for_variant
        .order(:variant_id, :country_iso, :currency)
        .page(params[:page]).per(Spree::Config.admin_variants_per_page)
    end

    def new
      @product = Spree::Product.find_by(slug: params[:product_id])
      @price = @product.price.new
      puts "product " + @product.id.to_s
      puts "price " + @price.id.to_s

      respond_to do |format|
        format.html { render layout: !request.xhr? }
        if request.xhr?
          format.js   { render layout: false }
        end
      end
    end

  end
