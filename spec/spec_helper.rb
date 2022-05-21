require 'fileutils'
require 'xlsx_templater'

SPEC_BASE_PATH = Pathname.new(File.expand_path(File.dirname(__FILE__)))

RSpec.configure do |config|
  [:expect_with, :mock_with].each do |method|
    config.send(method, :rspec) do |c|
      c.syntax = :expect
    end
  end
end

def get_shared_strings(file_path)
  unzipped = Zip::File.new(file_path)
  entries = unzipped.entries.select do |e| e.name =~ /sharedStrings/ end
  entries.inject("") do |str, e| str << e.get_input_stream.read end
end
