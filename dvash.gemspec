# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  # Variables:
  s.name = "dvash"
  s.version = "0.1.1"
  s.authors = "Ari Mizrahi"
  s.date = "2013-07-21"
  s.description = "Part honeypot, part defense system.  Opens up ports and simulates services in order to look like an attractive target.  Hosts that try to connect to the fake services are considered attackers and blocked from all access."
  s.summary = "Honeypot defense system"
  s.email = "codemunchies@gmail.com"
  s.homepage = "http://github.com/codemunchies/dvash"
  s.license = "GPL-3"

  # Pragmatically Gathered
  s.executables = "dvash"
  s.files = Dir["{lib,bin}/**/*"]
  s.files += [File.basename(__FILE__), "Gemfile", "README.md", "LICENSE"]
  s.require_paths = ["lib"]

  # Dependencies
  s.add_dependency("parseconfig", "~> 1.0")
end
