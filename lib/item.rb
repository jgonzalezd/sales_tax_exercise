class Item
  attr_reader :quantity, :name, :price

  def initialize(quantity:, name:, price:)
    @quantity = Integer(quantity)
    @name = String(name)
    @price = Float(price)
  end
end

