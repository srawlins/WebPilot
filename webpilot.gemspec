$:.push File.expand_path('../lib', __FILE__)
require 'webpilot/version'

Gem::Specification.new do |s|
  s.name        = 'webpilot'
  s.version     = WebPilot::Version
  s.authors     = ['Sam Rawlins']
  s.email       = ['katt-core@listserv.arizona.edu']
  s.homepage    = 'https://github.com/srawlins/WebPilot'
  s.summary     = %q{A facade for Selenium::WebDriver to make the library more ruby-esque.}
  s.description = %q{WebPilot is a wrapper for Selenium::WebDriver that makes the library more ruby-esque. Rather than inherit from Selenium::WebDriver, an instance of WebPilot has a Selenium::WebDriver as an attribute. It serves other functions rather than just extending Selenium::WebDriver, so it also wraps a logger, saves screenshots, etc.}

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ['lib']
  s.add_dependency 'headless'
  s.add_dependency 'log4r'
  s.add_dependency 'selenium-webdriver', '~> 2'
  s.add_development_dependency 'rspec', '~> 2.8'
end
