# A test class for others to inherit to prevent duplicate code

class BaseTest

  def initialize(driver, base_url, filename)
  	# Initialize parameters
  	# --------------------
  	# driver: (object) The selenium web driver
  	# base_url: (string) The base url of the web page we're visiting
  	# filename: The file currently being executed
  	@driver = driver
  	@base_url = base_url
  	@filename = filename
  end

  def failed(error_message)
  	# Print a generic message when a test has failed, take a screenshot and end the test.
  	# Parameters
  	# ----------
  	# error_message: (string) A message describing what went wrong with the test.
  	puts("Error: " + error_message)
  	self.take_screenshot()
  	@driver.quit()
  	exit()
  end

  def passed()
  	# Print a generic message when a test has passed
  	puts("Passed: " + @filename)
  end

  def take_screenshot()
  	# Take a screenshot with a defined name based on the time and the browser
  	millis = Time.now.to_f * 1000
  	if(defined?(@driver.name))
  		driver_name = @driver.name
  	else
  		driver_name = ""
  	end
  	@driver.save_screenshot("screenshots/" + driver_name + "-" + millis.to_s + "-screenshots.png")
  end

end
