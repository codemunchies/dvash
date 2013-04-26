# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "dvash"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ari Mizrahi"]
  s.date = "2013-04-01"
  s.description = "Part honeypot, part defense system.  Opens up ports and simulates services in order to look like an attractive target.  Hosts that try to connect to the fake services are considered attackers and blocked from all access."
  s.email = "codemunchies@gmail.com"
  s.executables = ["dvash"]
  s.files = ["lib/dvash/honeyports/ipv4/http.rb", "lib/dvash/honeyports/ipv6/http.rb", "lib/dvash/os/linux.rb", "lib/dvash/os/mac.rb", "lib/dvash/os/windows.rb", "lib/dvash/application.rb", "lib/dvash/validation.rb", "lib/dvash.rb", "dvash.gemspec", "Gemfile"]
  s.homepage = "http://github.com/codemunchies/dvash"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.25"
  s.summary = "Very alpha honeypot defense system"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<parseconfig>, ["~> 1.0"])
      s.add_runtime_dependency(%q<bundler>, ["~> 1.3"])
    else
      s.add_dependency(%q<parseconfig>, ["~> 1.0"])
      s.add_dependency(%q<bundler>, ["~> 1.3"])
    end
  else
    s.add_dependency(%q<parseconfig>, ["~> 1.0"])
    s.add_dependency(%q<bundler>, ["~> 1.3"])
  end
end
