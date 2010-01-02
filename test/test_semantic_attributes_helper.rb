require 'helper'

class TestSemanticAttributesHelper < Test::Unit::TestCase

  def setup
    setup_fixtures
  end

  def test__semantic_attributes_for__output_with_no_block
    expected = html <<-EOHTML
      <div class="attrtastic user">
      </div>
    EOHTML

    @template.semantic_attributes_for(@user)
    actual = @template.output_buffer.to_s
    assert_equal expected, actual

    @template.output_buffer.clear

    expected = html <<-EOHTML
      <div class="attrtastic blog">
      </div>
    EOHTML

    @template.semantic_attributes_for(@blog)
    actual = @template.output_buffer.to_s
    assert_equal expected, actual
  end

  def test__semantic_attributes_for__should_run_block
    block_run = false
    @template.semantic_attributes_for(@user) do |attr|
      block_run = true
    end

    assert block_run
  end

  def test__semantic_attributes_for__with_options
    expected = html <<-EOHTML
      <div class="simple show attrtastic user">
      </div>
    EOHTML

    @template.semantic_attributes_for(@user, :html => {:class => 'simple show'})
    actual = @template.output_buffer.to_s
    assert_equal expected, actual
  end

end
