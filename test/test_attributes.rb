require 'helper'

class TestAttributes < Test::Unit::TestCase

  def setup
    setup_fixtures
  end

  def test__attributes__shoul_run_block
    block_run = false
    @user_builder.attributes do
      block_run = true
    end

    assert block_run
  end

  def test__attributes__output_without_block
    expected = html <<-EOHTML
      <div class="attributes">
      </div>
    EOHTML

    @user_builder.attributes
    actual = @template.output_buffer.to_s

    assert_equal expected, actual
  end

  def test__attributes__output
    expected = html <<-EOHTML
      <div class="attributes">
        <ol>
        </ol>
      </div>
    EOHTML

    @user_builder.attributes do end
    actual = @template.output_buffer.to_s

    assert_equal expected, actual
  end

  def test__attributes__with_header
    expected = html <<-EOHTML
      <div class="attributes">
        <div class="legend">Legend</div>
        <ol>
        </ol>
      </div>
    EOHTML

    @user_builder.attributes "Legend" do end
    actual = @template.output_buffer.to_s
    assert_equal expected, actual

    @template.output_buffer.clear
    @user_builder.attributes :name => "Legend" do end
    actual = @template.output_buffer.to_s
    assert_equal expected, actual
  end

  def test__attributes__with_fields_list
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

    @user_builder.attributes :full_name, :email
    actual = @template.output_buffer.to_s
    assert_equal expected, actual
  end

  def test__attributes__with_fields_list_header_and_options
    expected = html <<-EOHTML
      <div class="attributes contact">
        <div class="legend">Contact</div>
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

    @user_builder.attributes "Contact", :full_name, :title, :email, :html => {:class => "contact"}, :display_empty => true
    actual = @template.output_buffer.to_s
    assert_equal expected, actual
  end

end
