require 'json'

require 'receipt_generator'

RSpec.describe 'Receipt acceptance - Input 1' do
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
end