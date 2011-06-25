require 'helper'

class TestAttributes < TestCase

  context "attributes" do

    setup do
      setup_fixtures
    end

    should "run block" do
      block_run = false
      @user_builder.attributes do
        block_run = true
      end

      assert block_run
    end

    should "generate output even when no block given" do
      expected = html <<-EOHTML
        <div class="attributes">
        </div>
      EOHTML
      actual = @user_builder.attributes

      assert_equal expected, actual
    end

    should "generate output with block given" do
      expected = html <<-EOHTML
        <div class="attributes">
          <ol>
          </ol>
        </div>
      EOHTML
      actual = @user_builder.attributes do end

      assert_equal expected, actual
    end

    should "show header" do
      expected = html <<-EOHTML
        <div class="attributes">
          <div class="legend"><span>Legend</span></div>
          <ol>
          </ol>
        </div>
      EOHTML
      actual = @user_builder.attributes "Legend" do end

      assert_equal expected, actual

      #@template.output_buffer.clear
      actual = @user_builder.attributes :name => "Legend" do end

      assert_equal expected, actual
    end

    context "with fields list" do

      should "generate output" do
        expected = html <<-EOHTML
          <div class="attributes">
            <ol>
              <li class="attribute">
                <span class="label">Full name</span>
                <span class="value">Doe, John</span>
              </li>
              <li class="attribute">
                <span class="label">Email</span>
                <span class="value">john@doe.com</span>
              </li>
            </ol>
          </div>
        EOHTML
        actual = @user_builder.attributes :full_name, :email

        assert_equal expected, actual
      end

      should "show header" do
        expected = html <<-EOHTML
          <div class="attributes contact">
            <div class="legend"><span>Contact</span></div>
            <ol>
              <li class="attribute">
                <span class="label">Full name</span>
                <span class="value">Doe, John</span>
              </li>
              <li class="attribute">
                <span class="label">Title</span>
                <span class="value"></span>
              </li>
              <li class="attribute">
                <span class="label">Email</span>
                <span class="value">john@doe.com</span>
              </li>
            </ol>
          </div>
        EOHTML
        actual = @user_builder.attributes "Contact", :full_name, :title, :email, :html => {:class => "contact"}, :display_empty => true

        assert_equal expected, actual
      end

    end

    context "with :for option" do
      should "yield block" do
        block_run = false
        @blog_builder.attributes :for => nil do |author|
          block_run = true
        end

        assert block_run
      end

    end

    context "with :for => :method_name pointing to single object" do

      should "allow to access inner object" do
        @blog_builder.attributes :for => :author do |author|

          assert_equal @blog.author, author.record
          assert_equal @blog.author, author.object

        end
      end

      should "generate output for given inner object" do
        actual = @blog_builder.attributes :for => :author do |author|

          expected = html <<-EOHTML
            <li class="attribute">
              <span class="label">Full name</span>
              <span class="value">Doe, John</span>
            </li>
          EOHTML

          actual = author.attribute :full_name
          assert_equal expected, actual

        end

        expected = html <<-EOHTML
          <div class="attributes user">
            <ol>
            </ol>
          </div>
        EOHTML

        assert_equal expected, actual
      end

      should "show header" do
        expected = html <<-EOHTML
          <div class="attributes user">
            <div class="legend"><span>Author</span></div>
            <ol>
            </ol>
          </div>
        EOHTML
        actual = @blog_builder.attributes "Author", :for => :author do |author|
        end

        assert_equal expected, actual
      end

      should "work with field list" do
        expected = html <<-EOHTML
          <div class="attributes user">
            <ol>
              <li class="attribute">
                <span class="label">Full name</span>
                <span class="value">Doe, John</span>
              </li>
            </ol>
          </div>
        EOHTML
        actual = @blog_builder.attributes :full_name, :for => :author

        assert_equal expected, actual
      end
    end

    context "with :for => object" do

      should "allow to acces given object" do
        @blog_builder.attributes :for => @user do |author|

          assert_equal @user, author.record
          assert_equal @user, author.object

        end
      end

      should "generate output for given inner object" do
        actual = @blog_builder.attributes :for => @user do |author|

          expected = html <<-EOHTML
            <li class="attribute">
              <span class="label">Full name</span>
              <span class="value">Doe, John</span>
            </li>
          EOHTML

          actual = author.attribute :full_name
          assert_equal expected, actual

        end

        expected = html <<-EOHTML
          <div class="attributes user">
            <ol>
            </ol>
          </div>
        EOHTML

        assert_equal expected, actual
      end

      should "show header" do
        actual = @blog_builder.attributes "Author", :for => @user do |author|
        end

        expected = html <<-EOHTML
          <div class="attributes user">
            <div class="legend"><span>Author</span></div>
            <ol>
            </ol>
          </div>
        EOHTML

        assert_equal expected, actual
      end

      should "work with field list" do
        expected = html <<-EOHTML
          <div class="attributes user">
            <ol>
              <li class="attribute">
                <span class="label">Full name</span>
                <span class="value">Doe, John</span>
              </li>
            </ol>
          </div>
        EOHTML
        actual = @user_builder.attributes :full_name, :for => @user

        assert_equal expected, actual
      end
    end

    context "with :for => :method_name pointing to collection" do

      should "allow to access inner objects one by one" do
        posts = []

        @blog_builder.attributes :for => :posts do |post|

          posts << post.record

        end

        assert_equal @blog.posts, posts
      end

      should "generate output for given objects" do
        expected = html <<-EOHTML
          <div class="attributes post">
            <ol>
            </ol>
          </div>
          <div class="attributes post">
            <ol>
            </ol>
          </div>
        EOHTML
        actual = @blog_builder.attributes :for => :posts do |post|
        end

        assert_equal expected, actual
      end

      should "show header" do
        expected = html <<-EOHTML
          <div class="attributes post">
            <div class="legend"><span>Post</span></div>
            <ol>
            </ol>
          </div>
          <div class="attributes post">
            <div class="legend"><span>Post</span></div>
            <ol>
            </ol>
          </div>
        EOHTML
        actual = @blog_builder.attributes "Post", :for => :posts do |post|
        end

        assert_equal expected, actual
      end

      should "work with field list" do
        expected = html <<-EOHTML
          <div class="attributes post">
            <ol>
              <li class="attribute">
                <span class="label">Title</span>
                <span class="value">Hello World!</span>
              </li>
            </ol>
          </div>
          <div class="attributes post">
            <ol>
              <li class="attribute">
                <span class="label">Title</span>
                <span class="value">Sorry</span>
              </li>
            </ol>
          </div>
        EOHTML
        actual = @blog_builder.attributes :title, :for => :posts

        assert_equal expected, actual
      end
    end

    context "with :for => collection" do

      should "allow to access inner objects one by one" do
        posts = []

        @blog_builder.attributes :for => @blog.posts do |post|

          posts << post.record

        end

        assert_equal @blog.posts, posts
      end

      should "generate output for given objects" do
        expected = html <<-EOHTML
          <div class="attributes post">
            <ol>
            </ol>
          </div>
          <div class="attributes post">
            <ol>
            </ol>
          </div>
        EOHTML
        actual = @blog_builder.attributes :for => @blog.posts do |post|
        end

        assert_equal expected, actual
      end

      should "show header" do
        expected = html <<-EOHTML
          <div class="attributes post">
            <div class="legend"><span>Post</span></div>
            <ol>
            </ol>
          </div>
          <div class="attributes post">
            <div class="legend"><span>Post</span></div>
            <ol>
            </ol>
          </div>
        EOHTML
        actual = @blog_builder.attributes "Post", :for => @blog.posts do |post|
        end

        assert_equal expected, actual
      end

      should "work with field list" do
        expected = html <<-EOHTML
          <div class="attributes post">
            <ol>
              <li class="attribute">
                <span class="label">Title</span>
                <span class="value">Hello World!</span>
              </li>
            </ol>
          </div>
          <div class="attributes post">
            <ol>
              <li class="attribute">
                <span class="label">Title</span>
                <span class="value">Sorry</span>
              </li>
            </ol>
          </div>
        EOHTML
        actual = @blog_builder.attributes :title, :for => @blog.posts

        assert_equal expected, actual
      end
    end

  end
end
