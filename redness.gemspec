$:.push File.expand_path("../lib", __FILE__)
require "version"

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
  s.add_dependency "rspec"
  s.add_dependency "redis", "~> 2.2.2"
  s.add_dependency "activesupport"
  s.add_dependency "timecop"
  s.require_paths = ["lib"]
end
