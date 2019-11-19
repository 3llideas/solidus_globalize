# frozen_string_literal: true

require 'globalize'
require 'friendly_id/globalize'

module SolidusGlobalize
  class Engine < Rails::Engine
    engine_name 'solidus_globalize'

    config.autoload_paths += %W(#{config.root}/lib)

    initializer "solidus_globalize.environment", before: :load_config_initializers do |_app|
      SolidusGlobalize::Config = SolidusGlobalize::Configuration.new
    end

    initializer "solidus_globalize.permitted_attributes",
      before: :load_config_initializers do |_app|
      taxon_attributes = {
        translations_attributes: [
          :id,
          :locale,
          :name,
          :description,
          :permalink,
          :meta_description,
          :meta_keywords,
          :meta_title,
        ]
      }
      Spree::PermittedAttributes.taxon_attributes << taxon_attributes

      option_value_attributes = {
        translations_attributes: [
          :id,
          :locale,
          :name,
          :presentation,
        ]
      }
      Spree::PermittedAttributes.option_value_attributes << option_value_attributes

      store_attributes = {
        translations_attributes: [
          :id,
          :locale,
          :name,
          :meta_description,
          :meta_keywords,
          :seo_title,
        ]
      }
      Spree::PermittedAttributes.store_attributes << store_attributes
    end

    def self.activate
      Dir.glob(File.join(root, "app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare(&method(:activate).to_proc)
  end
end
