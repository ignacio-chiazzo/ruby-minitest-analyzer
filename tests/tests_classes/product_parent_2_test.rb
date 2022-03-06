# frozen_string_literal: true

require_relative 'product_grand_parent_test'

class ProductParent2Test < ProductGrandParentTest
  def test_foo
    puts 'foo'
  end

  def test_bar
    puts 'bar'
  end
end
