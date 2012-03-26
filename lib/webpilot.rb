require 'bundler/setup'
require 'headless'
require 'log4r'
require 'selenium-webdriver'

$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

class WebPilot
  include Log4r
  attr_reader :driver, :logger

  extend Forwardable
  def_delegators :@driver, :close, :current_url, :execute_script, :navigate,
                           :page_source, :quit, :switch_to, :window_handle, :window_handles
  def_delegators :@logger, :debug, :info, :warn, :error, :fatal

  def initialize(options={})
    @browser        = options[:browser]        || :firefox
    @is_headless    = options[:is_headless]
    @pause_time     = options[:pause_time]     || 0.3
    @screenshot_dir = options[:screenshot_dir]
    @timeout        = options[:timeout]        || 8

    case
    when options[:logger].nil?
      @logger = Logger.new 'debug_log'
      null_outputter = IOOutputter.new 'null', File.open('/dev/null', 'w')
    when options[:logger].is_a?(Logger)
      @logger = options[:logger]
    when options[:logger] == 'STDOUT'
      @logger = Logger.new 'debug_log'
      @logger.outputters = Outputter.stdout
      @logger.level = DEBUG
    when options[:logger] == 'STDERR'
      @logger = Logger.new 'debug_log'
      @logger.outputters = Outputter.stderr
      @logger.level = DEBUG
    end

    if @is_headless
      @headless = Headless.new
      @headless.start
    end

    @driver = Selenium::WebDriver.for @browser
  end

  # Close all windows that have a current url of "about:blank". Must follow this with a call to
  # `#switch_to`, so that you know what window you're on.
  def close_blank_windows
    @driver.window_handles.each do |handle|
      @driver.switch_to.window(handle)
      @driver.close if @driver.current_url == 'about:blank'
    end
  end

  # Enlargens the text of an element, using `method` and `locator`, by changing the `font-size`
  # in the style to be `3em`. It uses the following Javascript:
  #
  #     hlt = function(c) { c.style.fontSize='3em'; }; return hlt(arguments[0]);
  def enlargen(method, locator)
    @logger.debug "    enlargen: Waiting up to #{@timeout} seconds to find_element(#{method}, #{locator})..."
    wait = Selenium::WebDriver::Wait.new(:timeout => @timeout)
    wait.until { find_element(method, locator) }
    element = find_element(method, locator)
    execute_script("hlt = function(c) { c.style.fontSize='3em'; }; return hlt(arguments[0]);", element)
  end

  def find_element(method, selector, options={})
    retries = 4
    sleep 0.1  # based on http://groups.google.com/group/ruby-capybara/browse_thread/thread/5e182835a8293def fixes "NS_ERROR_ILLEGAL_VALUE"
    begin
      @driver.find_element(method, selector)
    rescue Selenium::WebDriver::Error::NoSuchElementError, Selenium::WebDriver::Error::TimeOutError => e
      return nil if options[:no_raise]
      raise e
    rescue Selenium::WebDriver::Error::InvalidSelectorError => e
      raise e if retries == 0
      @logger.info "Caught a Selenium::WebDriver::Error::InvalidSelectorError: #{e}"
      @logger.info "Retrying..."
      pause 2
      retries -= 1
      retry
    end
  end

  def highlight(method, locator, ancestors=0)
    wait = Selenium::WebDriver::Wait.new(:timeout => @timeout)
    wait.until { find_element(method, locator) }
    element = find_element(method, locator)
    execute_script("hlt = function(c) { c.style.border='solid 1px rgb(255, 16, 16)'; }; return hlt(arguments[0]);", element)
    parents = ""
    red = 255

    ancestors.times do
      parents << ".parentNode"
      red -= (12*8 / ancestors)
      execute_script("hlt = function(c) { c#{parents}.style.border='solid 1px rgb(#{red}, 0, 0)'; }; return hlt(arguments[0]);", element)
    end
    pause
  end

  def pause(time = nil)
    @logger.debug "  breathing..."
    sleep (time || @pause_time)
  end

  def quit
    @driver.quit
    @headless.destroy if @is_headless
  end

  # Deselect all `<option>s` within a `<select>`, suppressing any `UnsupportedOperationError`
  # that Selenium may throw
  def safe_deselect_all(el)
    el.deselect_all
    rescue Selenium::WebDriver::Error::UnsupportedOperationError
  end

  # Select a frame by its `id`
  def select_frame(id)
    @driver.switch_to().frame(id)
    pause
  end

  # Create and execute a `Selenium::WebDriver::Wait` for finding an element by `method` and `selector`
  def wait_for(method, locator)
    @logger.debug "    wait_for: Waiting up to #{@timeout} seconds to find_element(#{method}, #{locator})..."
    wait = Selenium::WebDriver::Wait.new(:timeout => @timeout)
    sleep 0.1  # based on http://groups.google.com/group/ruby-capybara/browse_thread/thread/5e182835a8293def fixes "NS_ERROR_ILLEGAL_VALUE"
    wait.until { driver.find_element(method, locator) }
  end
end
