require 'order'

class ReceiptGenerator
  BASIC_TAX_RATE = 0.10
  IMPORT_TAX_RATE = 0.05

  EXEMPT_CATEGORIES = [
    'book',
    'chocolate', 'chocolates',
    'pill', 'pills'
  ].freeze
  
  def from_hash(hash)
    order = Order.from_hash(hash)

    sales_taxes = 0.0
    total = 0.0

    lines = order.items.map do |item|
      unit_tax = compute_unit_tax(item)
      line_tax = unit_tax * item.quantity
      sales_taxes += line_tax

      line_total = (item.price + unit_tax) * item.quantity
      total += line_total

      formatted_total = format('%.2f', round_money(line_total))
      "#{item.quantity} #{item.name}: #{formatted_total}"
    end

    formatted_sales_taxes = format('%.2f', round_money(sales_taxes))
    formatted_total = format('%.2f', round_money(total))

    (lines + [
      "Sales Taxes: #{formatted_sales_taxes}",
      "Total: #{formatted_total}"
    ]).join("\n")
  end

  private

  def compute_unit_tax(item)
    base_tax = exempt?(item) ? 0.0 : (item.price * BASIC_TAX_RATE)
    import_tax = imported?(item) ? (item.price * IMPORT_TAX_RATE) : 0.0
    round_to_nearest_0_05(base_tax + import_tax)
  end

  def exempt?(item)
    name = item.name.downcase
    EXEMPT_CATEGORIES.any? { |kw| name.include?(kw) }
  end

  def imported?(item)
    item.name.downcase.include?('imported')
  end

  # Round up to the nearest 0.05
  def round_to_nearest_0_05(amount)
    ((amount * 20).ceil) / 20.0
  end

  # Normalize to 2 decimals for accumulation safety
  def round_money(amount)
    (amount * 100).round / 100.0
  end
  
end