require 'spec_helper'
require 'zip'

describe 'integration test', integration: true do
  let(:data) do
    { 
      payee: 'JOHN',
      have_uin: true,
      have_ks: false,
    }
  end
  let(:base_path) { SPEC_BASE_PATH.join('example_input') }
  let(:input_file) { "#{base_path}/template.xlsx" }
  let(:output_dir) { "#{base_path}/tmp" }
  let(:output_file) { "#{output_dir}/output.xlsx" }
  before do
    FileUtils.rm_rf(output_dir) if File.exist?(output_dir)
    Dir.mkdir(output_dir)
  end

  context 'should process in incoming xlsx' do
    it 'generates a valid zip file (.xlsx)' do
      XlsxTemplater::XlsxCreator.new(input_file, data).generate_xlsx_file(output_file)

      archive = Zip::File.open(output_file)
      archive.close
    end

    it 'generates a file with the same contents as the input xlsx' do
      input_entries = Zip::File.open(input_file) { |z| z.map(&:name) }
      XlsxTemplater::XlsxCreator.new(input_file, data).generate_xlsx_file(output_file)
      output_entries = Zip::File.open(output_file) { |z| z.map(&:name) }

      expect(input_entries).to eq(output_entries)
    end

    it 'should replace the token' do
      XlsxTemplater::XlsxCreator.new(input_file, data).generate_xlsx_file(output_file)
      str = get_shared_strings(output_file)
      expect(str).to_not include("$PAYEE$")
      expect(str.force_encoding('UTF-8')).to include(data[:payee])
    end
  end
end
