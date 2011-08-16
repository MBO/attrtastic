require 'helper'

class TestSemanticAttributesHelper < TestCase

  context "semantic_attributes_helper" do

    setup do
      setup_fixtures
    end

    should "generate output event when no block given" do
      expected = html <<-EOHTML
        <div class="attrtastic blog">
          <div class="attributes">
            <ol>
              <li class="attribute">
                <span class="label">Name</span>
                <span class="value">IT Pro Blog</span>
              </li>
              <li class="attribute">
                <span class="label">Url</span>
                <span class="value">http://www.it.pro.blog</span>
              </li>
              <li class="attribute">
                <span class="label">Author full name</span>
                <span class="value">Doe, John</span>
              </li>
            </ol>
          </div>
        </div>
      EOHTML
      actual = @template.semantic_attributes_for(@blog)

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
      actual = @template.semantic_attributes_for(@user, :html => {:class => 'simple show'}) do |attr|
        true
      end

      assert_equal expected, actual
    end

  end

end
