require 'helper'

class SemanticAttributesHelper < Test::Unit::TestCase

  def setup
    setup_fixtures
  end

  def test_empty__semantic_attributes_for
    expected = html <<-EOHTML
      <div class="attrtastic user">
      </div>
    EOHTML

    @template.semantic_attributes_for(@user)
    actual = @template.output_buffer
    assert_equal expected, actual

    @template.output_buffer.clear

    expected = html <<-EOHTML
      <div class="attrtastic blog">
      </div>
    EOHTML
    @template.semantic_attributes_for(@blog)
    actual = @template.output_buffer
    assert_equal expected, actual
  end

  def test__semantic_attributes_for__should_run_block
    expected = html <<-EOHTML
      <div class="attrtastic user">
      </div>
    EOHTML

    block_run = false
    @template.semantic_attributes_for(@user) do
      block_run = true
    end

    assert block_run
  end

end
