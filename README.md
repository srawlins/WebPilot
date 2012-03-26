WebPilot
=====

Introduction
------------

WebPilot is a wrapper for `Selenium::WebDriver` that makes the library more ruby-esque. Rather than inherit from `Selenium::WebDriver`, an instance of `WebPilot` has a `Selenium::WebDriver` instance as an attribute. It serves other functions rather than just extending `Selenium::WebDriver`, so it also wraps a `Logger`, saves screenshots, etc.

Compatibility
-------------

WebPilot is tested on the following platforms:

* **ruby-1.9.3** on **Linux**

That is all.

Roadmap
-------

* Way More Tests :P
* screenshot functionality
* All of the Approximations from KaikiFS...

Installation
------------

    gem install webpilot

Contributing
------------

Please do! Contributing is easy. Please read the CONTRIBUTING.md document for more info. ... When it exists.

Usage
-----

WebPilot is meant to be used primarily as a helper for using Selenium with Cucumber, so that your step definitions are as short as possible, and never have to rescue from a Selenium exception.

    require 'webpilot'
    pilot = WebPilot.new(options)

### `WebPilot.new` options

* `:browser` should be one of the browsers supported by [WebDriver.for](http://selenium.googlecode.com/svn/trunk/docs/api/rb/Selenium/WebDriver.html#for-class_method)
* `:is_headless` should be a boolean, indicating whether to use `Selenium::WebDriver` should run under a headless X display, using the [headless](https://github.com/leonid-shevtsov/headless) gem.
* `:logger` can be one of several things:
  * `nil` will instantiate a logger that writes to `/dev/null`
  * `"STDOUT"` will instantiate a logger to `STDOUT`
  * `"STDERR"` will instantiate a logger to `STDERR`
  * an object that appears to be a `Logger` will then be assigned to `@logger`, not instantiating anything new
* `:pause_time` should be a Numeric (Fixnum or Float), representing the number of seconds that a call to `#pause` will pause for.
* `:screenshot_dir` is... not quite used yet. Stay tuned!
* `:timeout` is the default number of seconds that a Wait object should wait for.

Versioning
----------

WebPilot follows [Semantic Versioning](http://semver.org/) (at least approximately) version 2.0.0-rc1.

License
-------

Please see [LICENSE.md](WebPilot/blob/master/LICENSE.md).

