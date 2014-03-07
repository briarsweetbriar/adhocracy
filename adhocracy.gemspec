$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "adhocracy/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "adhocracy"
  s.version     = Adhocracy::VERSION
  s.authors     = ["timothycommoner"]
  s.email       = ["timothythehuman@gmail.com"]
  s.homepage    = "https://github.com/timothycommoner/adhocracy"
  s.summary     = "Adhocracy is group management engine for Rails."
  s.description = "Adhocracy is group management engine for Rails."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.0"

  s.add_development_dependency "pg"
  s.add_development_dependency "debugger"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "guard-spork"
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'shoulda'

  s.test_files = Dir["spec/**/*"]
end
