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
  end

end
