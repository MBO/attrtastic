require 'helper'

class TestAttrtastic < Test::Unit::TestCase

  def setup
    ActionView::Base.send :include, Attrtastic::SemanticAttributesHelper
  end

end
