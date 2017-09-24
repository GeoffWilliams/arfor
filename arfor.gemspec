# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'arfor/version'

Gem::Specification.new do |spec|
  spec.name          = "arfor"
  spec.version       = Arfor::VERSION
  spec.authors       = ["Declarative Systems"]
  spec.email         = ["sales@declarativesystems.com"]

  spec.summary       = %q{a cool tool to download bits n pieces for puppet}
  spec.description   = %q{make puppet installers quicker and more reliable}
  spec.homepage      = "https://github.com/declarativesystems/arfor/"
  spec.license       = "Apache-2.0"


  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "fakefs", "0.10.2"
  spec.add_development_dependency "sinatra", "1.4.8"

  spec.add_runtime_dependency "escort", "0.4.0"
  spec.add_runtime_dependency "pe_info", "0.2.1"
  spec.add_runtime_dependency 'ruby-progressbar', '1.8.1'
  spec.add_runtime_dependency "octokit", "~> 4.0"
  spec.add_runtime_dependency "highline", "1.7.8"
  spec.add_runtime_dependency "puppet"
  spec.add_runtime_dependency "pdqtest", "0.8.4"
  spec.add_runtime_dependency "travis"
end
