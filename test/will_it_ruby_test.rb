require "test_helper"

class WillItRubyTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::WillItRuby::VERSION
  end
end
