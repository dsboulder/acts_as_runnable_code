# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{acts_as_runnable_code}
  s.version = "1.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["David Stevenson"]
  s.date = %q{2009-04-07}
  s.description = %q{TODO}
  s.email = %q{david@flouri.sh}
  s.extra_rdoc_files = [
    "README.txt"
  ]
  s.files = [
    "History.txt",
    "Manifest.txt",
    "README.txt",
    "Rakefile",
    "VERSION.yml",
    "lib/acts_as_runnable_code.rb",
    "test/test_acts_as_runnable_code.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/dsboulder/acts_as_runnable_code}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Sandbox support gem to help define user-provided algorithms}
  s.test_files = [
    "test/test_acts_as_runnable_code.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
