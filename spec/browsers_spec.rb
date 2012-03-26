require File.join(File.dirname(File.expand_path(__FILE__)), 'spec_helper')

describe "WebPilot" do
  context "default" do
    before(:each) do
      @driver = WebPilot.new(:is_headless => true)
    end

    after(:each) do
      @driver.quit
    end

    it "should launch firefox by default" do
      @driver.navigate.to "http://www.google.com"
      ps_firefox = `ps -ef | grep "[f]irefox"`
      ps_firefox['foreground'].should_not == nil
    end
  end

  context "firefox" do
    before(:each) do
      @driver = WebPilot.new(:browser => :firefox, :is_headless => true)
    end

    after(:each) do
      @driver.quit
    end

    it "should launch firefox when specified" do
      @driver.navigate.to "http://www.google.com"
      ps_firefox = `ps -ef | grep "[f]irefox"`
      ps_firefox['foreground'].should_not == nil
    end
  end

  context "chrome" do
    before(:each) do
      begin
        @driver = WebPilot.new(:browser => :chrome, :is_headless => true)
      rescue Selenium::WebDriver::Error::WebDriverError => e
        @driver = nil
        @pending = true
        @exception = e
      end
    end

    after(:each) do
      @driver.quit unless @driver.nil?
    end

    it "should launch chrome when specified" do
      if @driver.nil? and @pending
        pending(@exception)
      else
        @driver.navigate.to "http://www.google.com"
        sleep 5
        ps_chrome = `ps -ef | grep "[c]hrom"`
        ps_chrome['foreground'].should_not == nil
      end
    end
  end
end
