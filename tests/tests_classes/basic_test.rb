require_relative "parent_test"
class BasicTest < ParentTest
  def test_1
    puts __method__
  end

  def test_2
    puts __method__
  end
end