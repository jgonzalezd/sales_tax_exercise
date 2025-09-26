require 'item'

class Order
  attr_reader :items

  def initialize(items: [])
    @items = items
  end

  def self.from_hash(hash)
    items = (hash['items'] || []).map do |h|
      Item.new(
        quantity: h['quantity'], 
        name: h['name'], 
        price: h['price'], 
        category: h['category'],
        imported: h['imported'] || false
      )
    end
    new(items: items)
  end
end
