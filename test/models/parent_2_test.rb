# frozen_string_literal: true

require_relative 'grand_parent_test'

class Parent2Test < GrandParentTest
  def test_c
    puts __method__
  end
end
