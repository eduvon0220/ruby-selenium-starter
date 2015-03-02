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
    puts("Failed: " + @filename + ": " + error_message)
    self.take_screenshot()
    @driver.quit()
    exit()
  end

  def keep_trying(function, attempts=60)
    # Continues to try the function without errors for a number of attempts before continuing. This solves
    # The problem of Selenium being inconsistent and erroring out because a browser is slow.
    # --------------------
    # function: (lambda) A lambda function that should at some point execute successfully.
    # attempts: (string) The number of attempts to keep trying before letting the test continue
    #
    # Returns the return value of the function we are trying
    i = 0
    while i < attempts
      begin
        return function.call  # It will only return if the assertion does not throw an exception
      rescue Exception
        # Do nothing
      end
      i+= 1
      sleep(1)  # This makes the function wait a second between attempt
    end
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
