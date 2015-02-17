# An example test to show how to structure your tests

require "./tests/base_test.rb"

class Test < BaseTest

  def initialize(driver, base_url, filename)
  	super(driver, base_url, filename)
  end

  def run()
    # Runs the tests. This is what will be called by run.rb
    # No need to quit the driver at end of test. The run.rb file will handle that
  end
end
