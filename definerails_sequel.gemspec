$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'definerails_sequel/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'definerails_sequel'
  s.version     = DefineRails::Sequel::VERSION
  s.authors     = ['DefineScope']
  s.email       = ['info@definescope.com']
  s.homepage    = 'http://www.definescope.com'
  s.summary     = 'Code that DefineScope Rails applications use for dealing with Sequel.'
  s.description = 'Code that DefineScope Rails applications use for dealing with Sequel.'
  s.license     = 'This code is the intellectual property of DefineScope.'

  s.files = Dir["{app,config,db,lib}/**/*", 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir["test/**/*"]

  #s.add_dependency 'rails', '>= 5.0.0.1'

  s.add_dependency 'sequel'
  s.add_dependency 'sequel-rails'

end
