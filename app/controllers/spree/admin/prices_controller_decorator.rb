module Spree
  module Admin
    class PricesController < ResourceController
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

    end
  end
end
