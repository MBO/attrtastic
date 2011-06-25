require 'helper'

class TestAttrtastic < TestCase

  context "Attrtastic" do

    setup do
      setup_fixtures
    end

    should "work with verbose syntax version" do
      expected = html <<-EOHTML
        <div class="attrtastic user">
          <div class="attributes">
          <div class="legend"><span>User</span></div>
            <ol>
              <li class="attribute strong">
                <span class="label">First name</span>
                <span class="value">John</span>
              </li>
              <li class="attribute">
                <span class="label">Last name</span>
                <span class="value">Doe</span>
              </li>
            </ol>
          </div>

          <div class="attributes">
            <div class="legend"><span>Contact</span></div>
            <ol>
              <li class="attribute">
                <span class="label">Email</span>
                <span class="value">john@doe.com</span>
              </li>
            </ol>
          </div>
        </div>
      EOHTML

      actual = @template.semantic_attributes_for(@user) do |attr|
        @template.output_buffer << attr.attributes("User") do
          @template.output_buffer << (attr.attribute :first_name, :html => {:class => :strong}).to_s
          @template.output_buffer << (attr.attribute :last_name).to_s
          @template.output_buffer << (attr.attribute :title).to_s
        end
        @template.output_buffer << attr.attributes(:name => "Contact") do
          @template.output_buffer << (attr.attribute :email).to_s
        end
      end

      assert_equal expected, actual
    end

    should "work with compact syntax version" do
      expected = html <<-EOHTML
        <div class="attrtastic user">
          <div class="attributes">
            <div class="legend"><span>User</span></div>
            <ol>
              <li class="attribute">
                <span class="label">First name</span>
                <span class="value">John</span>
              </li>
              <li class="attribute">
                <span class="label">Last name</span>
                <span class="value">Doe</span>
              </li>
            </ol>
          </div>

          <div class="attributes">
            <div class="legend"><span>Contact</span></div>
            <ol>
              <li class="attribute">
                <span class="label">Email</span>
                <span class="value">john@doe.com</span>
              </li>
            </ol>
          </div>
        </div>
      EOHTML

      actual = @template.semantic_attributes_for(@user) do |attr|
        @template.output_buffer << attr.attributes("User", :first_name, :last_name, :title)
        @template.output_buffer << attr.attributes("Contact", :email)
      end

      assert_equal expected, actual
    end

  end

end
