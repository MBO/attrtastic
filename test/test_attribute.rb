require 'helper'

class TestAttribute < Test::Unit::TestCase

  def setup
    setup_fixtures
  end

  def test__attribute__output
    expected = html <<-EOHTML
      <li class="attribute">
        <span class="label">Full name</span>
        <span class="value">Doe, John</span>
      </li>
    EOHTML

    actual = @user_builder.attribute(:full_name)
    assert_equal expected, actual
  end

  def test__attribute__with_empty_value
    actual = @user_builder.attribute(:title)
    assert_nil actual

    expected = html <<-EOHTML
      <li class="attribute">
        <span class="label">Title</span>
        <span class="value"></span>
      </li>
    EOHTML

    actual = @user_builder.attribute(:title, :display_empty => true)
    assert_equal expected, actual
  end

  def test__attribute__with_custom_label
    expected = html <<-EOHTML
      <li class="attribute">
        <span class="label">Name</span>
        <span class="value">Doe, John</span>
      </li>
    EOHTML

    actual = @user_builder.attribute(:full_name, :label => "Name")
    assert_equal expected, actual
  end

end
