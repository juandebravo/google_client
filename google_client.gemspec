# -*- encoding: utf-8 -*-
require File.expand_path('../lib/google_client/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["juandebravo"]
  gem.email         = ["juandebravo@gmail.com"]
  gem.summary       = %q{Ease way to get access to Google API.}
  gem.description   = %q{This gem is a wrapper on top of the Google API that allows a developer to handle calendars, events, contacts on behalf of the user.}
  gem.homepage      = "http://www.github.com/juandebravo/google_client"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "google_client"
  gem.require_paths = ["lib"]
  gem.version       = GoogleClient::VERSION

  gem.add_dependency("rest-client")
  gem.add_dependency("addressable")

  gem.add_development_dependency("rake")
  gem.add_development_dependency("rspec")
  gem.add_development_dependency("webmock")

end
