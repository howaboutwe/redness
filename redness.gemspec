$:.push File.expand_path("../lib", __FILE__)
require "redness/version"

Gem::Specification.new do |s|
  s.name = "redness"
  s.version = Redness::VERSION
  s.authors = [
    "Baldur Gudbjornsson",
    "Matt Vermaak",
    "Bryan Woods",
    "Kenneth Lay",
    "Marco Carag",
    "Conner Peirce"
  ]
  s.email = "dev@howaboutwe.com"
  s.summary = "Helpful Ruby classes for improved Redis data structures"
  s.description = "Helpful Ruby classes for improved Redis data structures"
  s.homepage = "http://github.com/howaboutwe/redness"
  s.licenses = ["MIT"]
  s.files = `git ls-files`.split("\n")
  s.add_runtime_dependency "json"
  s.add_development_dependency "rspec"
  s.add_runtime_dependency "redis", "~> 3.0.0"
  s.add_runtime_dependency "activesupport"
  s.add_development_dependency "timecop"
  s.add_development_dependency "rake"
  s.require_paths = ["lib"]
end
