# frozen_string_literal: true

require_relative 'grand_parent_test'

class Parent1Test < GrandParentTest
  def test_b
    puts __method__
  end
end
