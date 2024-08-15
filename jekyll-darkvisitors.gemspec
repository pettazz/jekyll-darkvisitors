# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jekyll-darkvisitors/version"
Gem::Specification.new do |spec|
  spec.name          = "jekyll-darkvisitors"
  spec.summary       = "Block AI scrapers with Dark Visitors"
  spec.description   = "Jekyll plugin to generate a robots.txt to block AI scrapers via the Dark Visitors API (https://darkvisitors.com)"
  spec.version       = Jekyll::DarkVisitors::VERSION
  spec.authors       = ["Nick Pettazzoni"]
  spec.email         = ["rubygems@n.pettazz.com"]
  spec.homepage      = "https://pettazz.com/jekyll-darkvisitors"
  spec.licenses      = ["GPL-3.0"]
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r!^(test|spec|features)/!) }
  spec.require_paths = ["lib"]
  spec.add_dependency "jekyll", "~> 4.0"

  raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.' unless spec.respond_to?(:metadata)
  spec.metadata['homepage_uri']           = spec.homepage
  spec.metadata['source_code_uri']        = 'https://github.com/pettazz/jekyll-darkvisitors'
  spec.metadata['rubygems_mfa_required']  = 'true'
end