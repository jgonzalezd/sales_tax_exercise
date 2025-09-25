require 'open3'

RSpec.describe 'CLI receipt' do
  let(:project_root) { File.expand_path('..', __dir__) }
  let(:fixtures_dir) { File.join(__dir__, 'fixtures', 'orders') }

  it 'prints the expected receipt for input1' do
    input_path = File.join(fixtures_dir, 'input1.json')
    cmd = [RbConfig.ruby, File.join(project_root, 'bin', 'receipt'), input_path]

    stdout_str, status = Open3.capture2(*cmd, chdir: project_root)
    expect(status.success?).to be true
    expect(stdout_str.strip).to eq([
      '2 book: 24.98',
      '1 music CD: 16.49',
      '1 chocolate bar: 0.85',
      'Sales Taxes: 1.50',
      'Total: 42.32'
    ].join("\n"))
  end
end