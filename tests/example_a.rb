# An example test to show how to structure your tests

require "./tests/base_test.rb"

class Test < BaseTest

  def initialize(driver, base_url, filename)
  	# inherit initialization variables from super class (base_test.rb)
  	super(driver, base_url, filename)
  end

  def run()
  	# Runs the tests. This is what will be getting called by run.rb
    @driver.navigate.to(@base_url + "/ncr")
		element = @driver.find_element(:name, 'q')
		element.send_keys "BrowserStack"
		element.submit
		puts @driver.title
		# No need to quit driver at the end of the test. The run.rb file will handle that.
  end
end
