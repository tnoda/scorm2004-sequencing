# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scorm2004/sequencing/version'

Gem::Specification.new do |gem|
  gem.name          = "scorm2004-sequencing"
  gem.version       = Scorm2004::Sequencing::VERSION
  gem.authors       = ["Takahiro Noda"]
  gem.email         = ["takahiro.noda@gmail.com"]
  gem.description   = %q{A sequencing engine that supports SCORM 2004 4th ed.}
  gem.summary       = %q{The scorm2004-sequencing gem provides a sequencing engine for SCORM 2004 LMSs based on Ruby 2.0.}
  gem.homepage      = "https://github.com/tnoda/scorm2004-sequencing"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
end
