require "./tests/base_test.rb"

class Test < BaseTest

  def initialize(driver, base_url, filename)
  	super(driver, base_url, filename)
  end

  def run()
    @driver.navigate.to(@base_url + "/ncr")
		element = @driver.find_element(:name, 'q')
		element.send_keys "BrowserStack"
		element.submit
		puts @driver.title
  end
end
