require File.join(File.dirname(__FILE__), *%w[.. lib attrtastic])
ActionView::Base.send :include, Attrtastic::SemanticAttributesHelper
