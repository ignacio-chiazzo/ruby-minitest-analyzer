require "minitest"
require "minitest/autorun"

class ParentTest < Minitest::Test
  def test_parent
    puts __method__
  end
end
