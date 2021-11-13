class Product
  def initialize(title, price)
    @title = title
    @price = price
  end

  attr_reader :title, :price
  
  def price=(value)
    raise "The price should be greater than 0" if value < 0
    @price = value
  end

  def title=(value)
    raise "The title should be present" unless value.present?
    @title = value
  end
end
