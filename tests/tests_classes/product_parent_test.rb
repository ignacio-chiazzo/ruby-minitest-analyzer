# frozen_string_literal: true

require_relative 'product_grand_parent_test'
require_relative '../models/product'

class ProductParentTest < ProductGrandParentTest
  def setup
    @product = Product.new('shoes', 10)
  end

  def test_can_create_product
    product = Product.new('sock', 1)
    assert_equal('sock', product.title)
    assert_equal(1, product.price)
  end

  def test_that_will_be_skipped
    skip 'test this later'
  end

  def test_that_will_be_skipped_second
    skip 'test this later'
  end

  class TitleTest < ProductParentTest
    def test_title_cannot_be_empty_first
      assert_raises(StandardError, 'the title should be present') do
        product = Product.new('title', 1)
        product.title = ''
      end
    end

    def test_title_cannot_be_empty_second
      assert_raises(StandardError, 'the title should be present') do
        product = Product.new('title', 1)
        product.title = ''
      end
    end

    def test_title_cannot_be_empty
      assert_raises(StandardError, 'the title should be present') do
        product = Product.new('title', 1)
        product.title = ''
      end
    end
  end

  class TitleTestTest < ProductParentTest
    def test_title_cannot_be_empty_first
      assert_raises(StandardError, 'the title should be present') do
        product = Product.new('title', 1)
        product.title = ''
      end
    end

    def test_title_cannot_be_empty_second
      assert_raises(StandardError, 'the title should be present') do
        product = Product.new('title', 1)
        product.title = ''
      end
    end

    def test_title_cannot_be_empty
      assert_raises(StandardError, 'the title should be present') do
        product = Product.new('title', 1)
        product.title = ''
      end
    end
  end
end
