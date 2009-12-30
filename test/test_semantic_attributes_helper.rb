require 'helper'

class SemanticAttributesHelper < Test::Unit::TestCase

  def setup
    setup_fixtures
  end

  def test_empty_semantic_attributes_for
    expected = html <<-EOHTML
      <div class="attrtastic user">
      </div>
    EOHTML

    @template.semantic_attributes_for(@user)
    actual = @template.output_buffer
    assert_equal expected, actual
  end

  def test_semantic_attributes_for
    expected = html <<-EOHTML
      <div class="attrtastic user">
      </div>
    EOHTML

    block_run = false
    @template.semantic_attributes_for(@user) do
      block_run = true
    end
    actual = @template.output_buffer

    assert block_run
    assert_equal expected, actual
  end

end
