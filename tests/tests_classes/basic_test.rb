# frozen_string_literal: true

require_relative 'parent_test'

class BasicTest < ParentTest
  def test_first
    puts __method__
  end

  def test_second
    puts __method__
  end
end
