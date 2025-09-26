class Item
  attr_reader :quantity, :name, :price, :category

  def initialize(quantity:, name:, price:, category: 'other', imported: false)
    @quantity = Integer(quantity)
    @name = String(name)
    @price = Float(price)
    @category = String(category)
    @imported = imported
  end
  
  def imported?
    @imported
  end
end

