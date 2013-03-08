# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "dvash"
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [""]
  s.date = "2013-03-08"
  s.description = ""
  s.email = ""
  s.executables = ["dvash"]
  s.files = ["Gemfile", "Gemfile.lock", "README.md", "Rakefile", "VERSION", "bin/dvash", "dvash.gemspec", "etc/dvash.conf", "lib/dvash.rb", "lib/dvash/application.rb", "lib/dvash/banner.rb", "lib/dvash/errors.rb", "lib/dvash/honeypot.rb", "lib/dvash/honeypots/ipv4/base.rb", "lib/dvash/honeypots/ipv4/http.rb", "lib/dvash/honeypots/ipv4/ssh.rb", "lib/dvash/honeypots/ipv4/telnet.rb", "lib/dvash/honeypots/ipv6/base.rb", "lib/dvash/honeypots/ipv6/http.rb", "lib/dvash/honeypots/ipv6/ssh.rb", "lib/dvash/logging.rb", "lib/dvash/multi_io.rb"]
  s.homepage = "http://github.com/codemunchies/dvash"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.25"
  s.summary = ""

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<parseconfig>, ["~> 1.0"])
      s.add_runtime_dependency(%q<rainbow>, ["~> 1.1"])
      s.add_runtime_dependency(%q<ansi>, ["~> 1.4"])
      s.add_runtime_dependency(%q<service>, ["~> 1.0"])
      s.add_runtime_dependency(%q<system>, ["~> 0.1"])
    else
      s.add_dependency(%q<parseconfig>, ["~> 1.0"])
      s.add_dependency(%q<rainbow>, ["~> 1.1"])
      s.add_dependency(%q<ansi>, ["~> 1.4"])
      s.add_dependency(%q<service>, ["~> 1.0"])
      s.add_dependency(%q<system>, ["~> 0.1"])
    end
  else
    s.add_dependency(%q<parseconfig>, ["~> 1.0"])
    s.add_dependency(%q<rainbow>, ["~> 1.1"])
    s.add_dependency(%q<ansi>, ["~> 1.4"])
    s.add_dependency(%q<service>, ["~> 1.0"])
    s.add_dependency(%q<system>, ["~> 0.1"])
  end
end
