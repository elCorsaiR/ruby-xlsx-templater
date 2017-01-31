$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require "xlsx_templater/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = 'xlsx_templater'.freeze
  s.version  = XlsxTemplater::VERSION

  s.authors     = ['S. Fedosov']
  s.email       = ['wolferingys@gmail.com']
  s.homepage    = 'https://github.com/Wolfer/smev'
  s.summary     = 'Generates new Excel .xlsx files based on a template file'
  s.description = 'Generates new Excel .xlsx files based on a template file'
  s.date        = '2017-01-30'

  s.files = Dir['{lib}/**/*'] + ['LICENSE.txt', 'Rakefile', 'README.rdoc']

  s.add_runtime_dependency 'nokogiri'
  s.add_runtime_dependency 'rubyzip',   '>= 1.0'
  s.add_development_dependency 'rake',  '>= 0'
  s.add_development_dependency 'rspec', '>= 0'

end
