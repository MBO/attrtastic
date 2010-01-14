require 'helper'

class TestAttribute < Test::Unit::TestCase

  context "attribute" do

    setup do
      setup_fixtures
    end

    should "generate output" do
      expected = html <<-EOHTML
        <li class="attribute">
          <span class="label">Full name</span>
          <span class="value">Doe, John</span>
        </li>
      EOHTML

      actual = @user_builder.attribute(:full_name)
      assert_equal expected, actual
    end

    should "not show attribute when value is blank" do
      actual = @user_builder.attribute(:title)
      assert_nil actual
    end

    should "show attribute with :display_empty => true" do
      expected = html <<-EOHTML
        <li class="attribute">
          <span class="label">Title</span>
          <span class="value"></span>
        </li>
      EOHTML

      actual = @user_builder.attribute(:title, :display_empty => true)
      assert_equal expected, actual
    end

    should "convert nested object to value" do
      expected = html <<-EOHTML
        <li class="attribute">
          <span class="label">Author</span>
          <span class="value">Doe, John</span>
        </li>
      EOHTML

      actual = @blog_builder.attribute(:author_full_name, :label => "Author")
      assert_equal expected, actual

      actual = @blog_builder.attribute(:author)
      assert_equal expected, actual
    end

    should "show custom label" do
      expected = html <<-EOHTML
        <li class="attribute">
          <span class="label">Name</span>
          <span class="value">Doe, John</span>
        </li>
      EOHTML

      actual = @user_builder.attribute(:full_name, :label => "Name")
      assert_equal expected, actual
    end

    should "show custom value" do
      expected = html <<-EOHTML
        <li class="attribute">
          <span class="label">Full name</span>
          <span class="value">Sir Doe, John</span>
        </li>
      EOHTML

      actual = @user_builder.attribute(:full_name, :value => "Sir #{@user.full_name}")
      assert_equal expected, actual
    end

    should "work with custom value blank" do
      assert_nil @user_builder.attribute(:full_name, :value => nil)
      assert_nil @user_builder.attribute(:full_name, :value => "")

      expected = html <<-EOHTML
        <li class="attribute">
          <span class="label">Full name</span>
          <span class="value"></span>
        </li>
      EOHTML

      actual = @user_builder.attribute(:full_name, :value => nil, :display_empty => true)
      assert_equal expected, actual

      actual = @user_builder.attribute(:full_name, :value => "", :display_empty => true)
      assert_equal expected, actual
    end


    context "with block" do

      should "yield block" do
        block_run = false
        @user_builder.attribute :full_name do
          block_run = true
        end
        assert block_run
      end

      should "generate output" do
        expected = html <<-EOHTML
        <li class="attribute">
          <span class="label">Full name</span>
          <span class="value">John Doe!!!</span>
        </li>
        EOHTML

        @user_builder.attribute :full_name do
          @user_builder.template.output_buffer << "John Doe"
          3.times do
            @user_builder.template.output_buffer << "!"
          end
        end
        actual = @template.output_buffer.to_s
        assert_equal expected, actual
      end

      should "show custom label" do
        expected = html <<-EOHTML
        <li class="attribute">
          <span class="label">Full name</span>
          <span class="value">John Doe!!!</span>
        </li>
        EOHTML

        @user_builder.attribute :label => "Full name" do
          @user_builder.template.output_buffer << "John Doe"
          3.times do
            @user_builder.template.output_buffer << "!"
          end
        end
        actual = @template.output_buffer.to_s
        assert_equal expected, actual
      end

    end
  end

end

