require 'helper'

class TestAttribute < Test::Unit::TestCase

  def setup
    setup_fixtures
  end

  def test__attribute__output
    expected = html <<-EOHTML
      <li>
        <span class="label">Full name</span>
        <span class="value">Doe, John</span>
      </li>
    EOHTML

    actual = @user_builder.attribute(:full_name)
    assert_equal expected, actual
  end

end
