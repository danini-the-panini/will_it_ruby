require "test_helper"

class GemologistTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Gemologist::VERSION
  end
end
