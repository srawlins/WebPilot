require File.join(File.dirname(File.expand_path(__FILE__)), 'spec_helper')

describe "WebPilot" do
  before(:each) do
    @driver = WebPilot.new(:is_headless => true)
  end

  after(:each) do
    @driver.quit
  end

  it "should do some basics" do
    @driver.navigate.to "http://www.google.com"
    @driver.find_element(:css, '#gbqfq').send_keys('mwrc ruby')
    @driver.find_element(:css, '#gbqfb').click
    @driver.wait_for(:xpath, "//ol[@id='rso']/li//a")
    @driver.find_element(:xpath, "//ol[@id='rso']/li//a").click
  end
end
