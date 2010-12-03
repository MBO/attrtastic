require 'attrtastic'
require 'rails'

module Attrtastic
  class Railtie < Rails::Railtie
    initializer 'attrtastic.initialize', :after => :after_initialize do
      ActionView::Base.send :include, Attrtastic::SemanticAttributesHelper
    end
  end
end
