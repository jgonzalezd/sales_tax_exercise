require 'json'

require 'receipt_generator'

RSpec.describe 'Receipt Generator acceptance tests' do
  let(:fixtures_dir) { File.join(__dir__, 'fixtures', 'orders') }

  it 'prints the expected receipt for input1' do
    data = JSON.parse(File.read(File.join(fixtures_dir, 'input1.json')))
    output = ReceiptGenerator.new.from_hash(data)

    expect(output).to eq(
      [
        '2 book: 24.98',
        '1 music CD: 16.49',
        '1 chocolate bar: 0.85',
        'Sales Taxes: 1.50',
        'Total: 42.32'
      ].join("\n")
    )
  end

  it 'prints the expected receipt for input2' do
    data = JSON.parse(File.read(File.join(fixtures_dir, 'input2.json')))
    output = ReceiptGenerator.new.from_hash(data)

    expect(output).to eq(
      [
        '1 imported box of chocolates: 10.50',
        '1 imported bottle of perfume: 54.65',
        'Sales Taxes: 7.65',
        'Total: 65.15'
      ].join("\n")
    )
  end

  it 'prints the expected receipt for input3' do
    data = JSON.parse(File.read(File.join(fixtures_dir, 'input3.json')))
    output = ReceiptGenerator.new.from_hash(data)

    expect(output).to eq(
      [
        '1 imported bottle of perfume: 32.19',
        '1 bottle of perfume: 20.89',
        '1 packet of headache pills: 9.75',
        '3 imported box of chocolates: 35.55',
        'Sales Taxes: 7.90',
        'Total: 98.38'
      ].join("\n")
    )
  end

  it 'handles non-exempt imported items with multiple quantity' do
    data = JSON.parse(File.read(File.join(fixtures_dir, 'input4.json')))
    output = ReceiptGenerator.new.from_hash(data)
    expect(output).to eq(
      [
        '2 imported bottle of perfume: 109.30',
        'Sales Taxes: 14.30',
        'Total: 109.30'
      ].join("\n")
    )
  end

  it 'handles imported exempt items with rounding edge cases' do
    data = JSON.parse(File.read(File.join(fixtures_dir, 'input5.json')))
    output = ReceiptGenerator.new.from_hash(data)
    expect(output).to eq(
      [
        '1 imported box of chocolates: 11.84',
        'Sales Taxes: 0.60',
        'Total: 11.84'
      ].join("\n")
    )
  end

  it 'handles non-exempt items with no rounding change' do
    data = JSON.parse(File.read(File.join(fixtures_dir, 'input6.json')))
    output = ReceiptGenerator.new.from_hash(data)
    expect(output).to eq(
      [
        '1 music CD: 11.00',
        'Sales Taxes: 1.00',
        'Total: 11.00'
      ].join("\n")
    )
  end

  it 'handles non-exempt items with a tiny price' do
    data = JSON.parse(File.read(File.join(fixtures_dir, 'input7.json')))
    output = ReceiptGenerator.new.from_hash(data)
    expect(output).to eq(
      [
        '1 music CD: 0.06',
        'Sales Taxes: 0.05',
        'Total: 0.06'
      ].join("\n")
    )
  end

  it 'handles import detection regardless of word position' do
    data = JSON.parse(File.read(File.join(fixtures_dir, 'input8.json')))
    output = ReceiptGenerator.new.from_hash(data)
    expect(output).to eq(
      [
        '1 box of imported chocolates: 10.50',
        'Sales Taxes: 0.50',
        'Total: 10.50'
      ].join("\n")
    )
  end

  it 'does not incorrectly exempt items (e.g. notebook)' do
    data = JSON.parse(File.read(File.join(fixtures_dir, 'input9.json')))
    output = ReceiptGenerator.new.from_hash(data)
    expect(output).to eq(
      [
        '1 notebook: 13.74',
        'Sales Taxes: 1.25',
        'Total: 13.74'
      ].join("\n")
    )
  end

  it 'handles a multi-item mixed basket correctly' do
    data = JSON.parse(File.read(File.join(fixtures_dir, 'input10.json')))
    output = ReceiptGenerator.new.from_hash(data)
    expect(output).to eq(
      [
        '1 notebook: 13.74',
        '1 imported box of chocolates: 11.84',
        '2 imported bottle of perfume: 109.30',
        'Sales Taxes: 16.15',
        'Total: 134.88'
      ].join("\n")
    )
  end
end