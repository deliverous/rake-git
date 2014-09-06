Gem::Specification.new do |spec|
  spec.name = "rake-git"
  spec.version = "0.0.1"
  spec.platform = Gem::Platform::RUBY
  spec.authors = ["Deliverous R&D"]
  spec.email = ["contact@deliverous.com"]
  spec.homepage = "http://deliverous.com/"
  spec.summary = "Rake tasks relative to git"
  spec.description = ""

  spec.required_rubygems_version = ">= 1.3.6"

  spec.add_dependency 'colorize'
  spec.add_dependency 'rake'

  spec.files = Dir["{lib}/**/*.rb", "{lib}/**/*.erb", "{bin}/*", "{lib}/**/*.rake", "{lib}/**/*.yml", "LICENSE", "*.md", "templates/**"]
  spec.bindir = 'bin'

  spec.require_path = 'lib'
  #spec.license       = 'MIT'
end
