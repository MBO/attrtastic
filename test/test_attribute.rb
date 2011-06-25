require 'helper'

class TestAttribute < TestCase

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

    context "with default formating" do
      should "properly format a String" do
        expected = html <<-EOHTML
          <li class="attribute">
            <span class="label">Author</span>
            <span class="value">Doe, John</span>
          </li>
        EOHTML
        actual = @blog_builder.attribute(:author_full_name, :label => "Author")
        assert_equal expected, actual
      end

      should "properly format a Date" do
        expected = html <<-EOHTML
          <li class="attribute">
          <span class="label">Birthday</span>
            <span class="value">1953-06-03</span>
          </li>
        EOHTML
        actual = @user_builder.attribute(:birthday)
        assert_equal expected, actual
      end

      should "properly format a DateTime" do
        expected = html <<-EOHTML
          <li class="attribute">
          <span class="label">Created at</span>
            <span class="value">Thu, 02 Jun 2011 12:06:42 +0000</span>
          </li>
        EOHTML
        actual = @user_builder.attribute(:created_at)
        assert_equal expected, actual
      end

      should "properly format a Time" do
        expected = html <<-EOHTML
          <li class="attribute">
          <span class="label">Time</span>
            <span class="value">Sat, 01 Jan 2000 06:00:00 +0100</span>
          </li>
        EOHTML
        actual = @user_builder.attribute(:time)
        assert_equal expected, actual
      end

      should "properly format a Float" do
        expected = html <<-EOHTML
          <li class="attribute">
          <span class="label">Float</span>
            <span class="value">54424.220</span>
          </li>
        EOHTML
        actual = @user_builder.attribute(:float)
        assert_equal expected, actual
      end

      should "properly format a Decimal" do
        expected = html <<-EOHTML
          <li class="attribute">
          <span class="label">Decimal</span>
            <span class="value">4454.344</span>
          </li>
        EOHTML
        actual = @user_builder.attribute(:decimal)
        assert_equal expected, actual
      end

      should "properly format a Integer" do
        expected = html <<-EOHTML
          <li class="attribute">
          <span class="label">Integer</span>
            <span class="value">45,453</span>
          </li>
        EOHTML
        actual = @user_builder.attribute(:integer)
        assert_equal expected, actual
      end
    end

    context "with default formating disabled" do
      should "properly format a String" do
        expected = html <<-EOHTML
          <li class="attribute">
            <span class="label">Author</span>
            <span class="value">Doe, John</span>
          </li>
        EOHTML
        actual = @blog_builder.attribute(:author_full_name, :label => "Author", :format => false)
        assert_equal expected, actual
      end

      should "properly format a Date" do
        expected = html <<-EOHTML
          <li class="attribute">
          <span class="label">Birthday</span>
            <span class="value">1953-06-03</span>
          </li>
        EOHTML
        actual = @user_builder.attribute(:birthday, :format => false)
        assert_equal expected, actual
      end

      should "properly format a DateTime" do
        expected = html <<-EOHTML
          <li class="attribute">
          <span class="label">Created at</span>
            <span class="value">2011-06-02T12:06:42+00:00</span>
          </li>
        EOHTML
        actual = @user_builder.attribute(:created_at, :format => false)
        assert_equal expected, actual
      end

      should "properly format a Time" do
        expected = html <<-EOHTML
          <li class="attribute">
          <span class="label">Time</span>
            <span class="value">2000-01-01 06:00:00 +0100</span>
          </li>
        EOHTML
        actual = @user_builder.attribute(:time, :format => false)
        assert_equal expected, actual
      end

      should "properly format a Float" do
        expected = html <<-EOHTML
          <li class="attribute">
          <span class="label">Float</span>
            <span class="value">54424.22</span>
          </li>
        EOHTML
        actual = @user_builder.attribute(:float, :format => false)
        assert_equal expected, actual
      end

      should "properly format a Decimal" do
        expected = html <<-EOHTML
          <li class="attribute">
          <span class="label">Decimal</span>
            <span class="value">4454.3435</span>
          </li>
        EOHTML
        actual = @user_builder.attribute(:decimal, :format => false)
        assert_equal expected, actual
      end

      should "properly format a Integer" do
        expected = html <<-EOHTML
          <li class="attribute">
          <span class="label">Integer</span>
            <span class="value">45453</span>
          </li>
        EOHTML
        actual = @user_builder.attribute(:integer, :format => false)
        assert_equal expected, actual
      end
    end

    context "with custom formating" do
      should "output the return value of called template's method" do
        expected = html <<-EOHTML
          <li class="attribute">
            <span class="label">Author</span>
            <span class="value">Hello, my name is Doe, John</span>
          </li>
        EOHTML
        def @template.hello(name)
          "Hello, my name is #{name}"
        end
        actual = @blog_builder.attribute(:author_full_name, :label => "Author", :format => :hello)
        assert_equal expected, actual
      end
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

    should "use th custome value as hash key if it's a symbol and the attribute is a hash" do
      expected = html <<-EOHTML
        <li class="attribute">
        <span class="label">Address</span>
          <span class="value">Hellway 13</span>
        </li>
      EOHTML

      actual = @user_builder.attribute(:address, :value => :street)
      assert_equal expected, actual
    end

    should "use th custome value as a method it's a symbol and the attribute is not a hash" do
      expected = html <<-EOHTML
        <li class="attribute">
        <span class="label">Blog</span>
          <span class="value">IT Pro Blog</span>
        </li>
      EOHTML

      actual = @user_builder.attribute(:blog, :value => :name)
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

        actual = @user_builder.attribute :full_name do
          @user_builder.template.output_buffer << "John Doe"
          3.times do
            @user_builder.template.output_buffer << "!"
          end
        end
        assert_equal expected, actual
      end

      should "show custom label" do
        expected = html <<-EOHTML
        <li class="attribute">
          <span class="label">Full name</span>
          <span class="value">John Doe!!!</span>
        </li>
        EOHTML

        actual = @user_builder.attribute :label => "Full name" do
          @user_builder.template.output_buffer << "John Doe"
          3.times do
            @user_builder.template.output_buffer << "!"
          end
        end
        assert_equal expected, actual
      end

    end
  end

end

