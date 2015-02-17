class BaseTest

  def initialize(driver, base_url, filename)
  		@driver = driver
  		@base_url = base_url
  		@filename = filename
  end

  def failed(error_message)
  	puts("Error: " + error_message)
  	self.take_screenshot()
  	@driver.quit()
  	exit()
  end

  def passed()
  	puts("Passed: " + @filename)
  end

  def take_screenshot()
  	millis = Time.now.millis
  	@driver.save_screenshot("screenshots/" + @driver.name + "-" + millis.to_s + "-screenshots.png")
  end

end
