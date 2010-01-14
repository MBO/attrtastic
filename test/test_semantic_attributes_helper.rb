require 'helper'

class TestSemanticAttributesHelper < Test::Unit::TestCase

  context "semantic_attributes_helper" do

    setup do
      setup_fixtures
    end

    should "generate output event when no block given" do
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

    should "run block" do
      block_run = false
      @template.semantic_attributes_for(@user) do |attr|
        block_run = true
      end

      assert block_run
    end

    should "accept options" do
      expected = html <<-EOHTML
        <div class="attrtastic user simple show">
        </div>
      EOHTML

      @template.semantic_attributes_for(@user, :html => {:class => 'simple show'})
      actual = @template.output_buffer.to_s
      assert_equal expected, actual
    end

  end

end
