require 'selenium-webdriver' # must install this as a gem on your local machine
require 'optparse' # included as part of ruby library

# set up the command line arguments
options = {}

opt_parser = OptionParser.new do |opts|
  opts.banner = "Usage: run.rb [options]"

  opts.on("--desktop", "(boolean) Make the tests only run tests on desktop computers.") do |d|
    options[:desktop] = d
  end

  opts.on("--mobile", "(boolean) Make the tests only run tests on mobile devices.") do |m|
    options[:mobile] = m
  end

  opts.on("--use_local", "(boolean) Use the local Browserstack selenium testing.") do |l|
    options[:use_local] = l
  end

  opts.on("--base_url x", "A way to override the DEFAULT_BASE_URL for your tests.") do |base_url|
    options[:base_url] = base_url
  end

  opts.on("--test x", "Only run one test as specified") do |t|
    options[:test] = t
  end

  desired_cap_config_notes = " The available values you can pass to this command will depend on the values you have set in your config.rb file"

  opts.on("--browser x", "Desktop: Only run tests on the given browser." + desired_cap_config_notes) do |b|
    options[:browser] = b
  end

  opts.on("--browser_version x", "Desktop: Only run tests on the given browser version." + desired_cap_config_notes) do |b|
    options[:browser_version] = b
  end

  opts.on("--os x", "Desktop: Only run tests on the given operating system." + desired_cap_config_notes) do |o|
    options[:os] = o
  end

  opts.on("--os_version x", "Desktop: Only run tests on the given operating system version." + desired_cap_config_notes) do |o|
    options[:os_version] = o
  end

  opts.on("--resolution x", "Desktop: Only run tests on the given screen resolution." + desired_cap_config_notes) do |r|
    options[:resolution] = r
  end

  opts.on("--browserName x", "Mobile: Only run tests on the given mobile browser name." + desired_cap_config_notes) do |b|
    options[:browserName] = b
  end

  opts.on("--platform x", "Mobile: Only run tests on the given mobile platforms." + desired_cap_config_notes) do |p|
    options[:platform] = p
  end

  opts.on("--device x", "Mobile: Only run tests on the given mobile device." + desired_cap_config_notes) do |d|
    options[:device] = d
  end

  opts.on("--capabilities", "Example: \"{'browser': 'IE', 'browser_version': '8.0', 'os': 'Windows', " + 
    "'os_version': '7', 'resolution': '1024x768'}\" Can be used as an alternative to adding many of" + 
    "the arguments above such as mobile, desktop, browser, browser_version, etc.") do |c|
    options[:capabilities] = c
  end

  opts.on("--browserstack", "This will make tests execute on the browserstack platform instead" +
    "the above flags will be ignored") do |c|
    options[:browserstack] = c
  end

end

opt_parser.parse!

#IMPORT ALL VARIABLES
require "./config"

if (options[:base_url])
  # Override the DEFAULT_BASE_URL value if passed in via the command line arg
  BASE_URL = options[:base_url]
else
  BASE_URL = DEFAULT_BASE_URL
end

# Grab the authentication variables from the environment
begin
  selenium_username = ENV.fetch('SELENIUM_AUTOMATE_USERNAME')
  selenium_value = ENV.fetch('SELENIUM_AUTOMATE_VALUE')
rescue
  puts "You need to set the environment variables for you username and value. See the README.md for details"
end

if (BASE_URL == "")
  puts "You need to set your DEFAULT_BASE_URL variable at the top of config.py"
end

# If browserstack is set to be used then set up desired capabilities array, etc.
if (options[:browserstack])

  # This has been set as an array so we can set multiple environments and run the tests below
  # in a for loop to repeat the tests for different operating systems. I have set a mobile capability
  # list and desktop capability list to allow the use of either or with a flag. More tests can easily be added.
  # See the browserstack website to get more options.
  # The below tests IE8, IE9, IE10 and IE11 on windows and then chrome, safari, and firefox on Mac.
  # Pay attention to the version numbers.
  desktop_cap_list = DESKTOP_CAP_LIST_CONFIGS

  # The below tests on iPhone 5 and Samsung Galaxy S5. If your Selenium Automate plan doesn't include Mobile,
  # you will want to change the following to mobile_cap_list = []
  mobile_cap_list = MOBILE_CAP_LIST_CONFIGS

  # Conditionally create the desired_cap_list list. Didn't use elsif statements to allow for more user error.
  desired_cap_list = []
  if (options[:desktop])
    # If the desktop argument has been passed, then only run the desktop tests
    desired_cap_list += desktop_cap_list
  end
  if (options[:mobile])
    # If the mobile argument has been passed, then only run the mobile tests
    desired_cap_list += mobile_cap_list
  end
  if (desired_cap_list.empty?)
    # If no desktop or mobile argument has been passed, then run both the desktop and mobile tests
    desired_cap_list = desktop_cap_list + mobile_cap_list
  end
  # If a specific filter arg was set via the command line, remove anything from the desired_capabilities list that does not meet the requirement
  desired_cap_list_filters = [
    :os,
    :browser,
    :browser_version,
    :resolution,
    :os_version,
    :browserName,
    :platform,
    :device
  ]

  desired_cap_list_filters.each do |the_filter|
  # Loops through the list above so as only to use the options that are passed in.
  # if a filter is passed through command line (like 'os') then continue within for loop
    if (options[the_filter])
        temp_list = desired_cap_list
        desired_cap_list = []
        temp_list.each do |desired_cap|
          if (desired_cap.has_key?(the_filter) && desired_cap[the_filter] == options[the_filter])
            desired_cap_list << desired_cap
          end
        end
    end
  end
# If the --browserstack argument was not passed, just set one element in the desired_cap_list
# for the sake of using the same logic below. When looping through the elements of the desired_cap_list
else
  desired_cap_list = [{browser: "Firefox"}]
end

# This will run the same test code in multiple environments
desired_cap_list.each do |desired_cap|
  # If the browserstack argument was passed, then use the following to output the test headers
  if (options[:browserstack])
    # Output a line to show what environment is now being tested
    if (desired_cap[:browser])
      # For desktop on browserstack
      puts "\nStarting Tests on %s %s on %s %s with a screen resolution of %s " %
      [desired_cap[:browser], desired_cap[:browser_version], desired_cap[:os], desired_cap[:os_version], desired_cap[:resolution]]
    else
      # For mobile on browserstack
      puts "\nStarting Tests on a %s" % [desired_cap[:device]]
    end
    # Otherwise, just simply output this message
  else
    # For desktop on local machine using firefox
    puts "\nStarting Tests on %s on your local machine" % [desired_cap[:browser]]
  end

  puts "------------------------------------------------------\n"

  # If the browserstack argument was passed, then dynamically set up the remote driver.
  if (options[:browserstack])
    caps = Selenium::WebDriver::Remote::Capabilities.new
    # If the "os" option is passed, use the desktop capabilities
    if (desired_cap.has_key?("os"))
      caps["browser"] = desired_cap[:browser]
      caps["browser_version"] = desired_cap[:browser_version]
      caps["os"] = desired_cap[:os]
      caps["os_version"] = desired_cap[:os_version]
      caps["resolution"] = desired_cap[:resolution]
    end
    # If the "device" option is passed, use the mobile capabilities
    if (desired_cap.has_key?("device"))
      caps["browserName"] = desired_cap[:browserName]
      caps["platform"] = desired_cap[:platform]
      caps["device"] = desired_cap[:device]
    end
    # Use browserstack local testing if the argument was passed
    if (options[:use_local])
      cap['browserstack.local'] = true
    end
    driver = Selenium::WebDriver.for(:remote,
      :url => "http://%s:%s@hub.browserstack.com:80/wd/hub" % [selenium_username, selenium_value],
      :desired_capabilities => desired_cap)
  else
    # Otherwise, just run firefox locally.
    driver = Selenium::WebDriver.for :firefox
  end

  tests_to_run = []
  # If no specific test was specified, add all tests to the array of tests to run
  unless (options.has_key?(:test))
    # Dynamically search the tests folder to add all of those files to the tests to run array
    Dir['tests/*.rb'].each do |fname|
      # Remove "tests/" from the filename
      fname.slice!("tests/")
      # Add the tests to the array except for base_test.rb which is the super class
      unless(fname == "base_test.rb")
        tests_to_run << fname
      end
    end
  # If a specific test was specified, just add the specified test to the array of tests to run
  else
    tests_to_run << options[:test]
  end
  # The time when the tests started
  all_tests_start_time = Time.now().to_f
  # Loops through all the tests_to_run and runs them
  tests_to_run.each do |test|
    this_test_start_time = Time.now().to_f
    # This dynamically requires all files into the tests_to_run list
    require "./tests/" + test 
    # Instantiates a test and runs it
    current_test = Test.new(driver, BASE_URL, test)
    current_test.run()

    # If it makes it this far, this means the test passed
    current_test.passed()

    # Output the amount of time it took this test to run on the current platform
    this_test_seconds_taken = Time.now().to_f - this_test_start_time
    if(this_test_seconds_taken > 60)
      puts "Time Taken: " + (this_test_seconds_taken/60).to_s + " minutes"
    else
      puts "Time Taken: " + (this_test_seconds_taken).to_s + " seconds"
    end
  end

  puts "--------------------------------------------------------\n"
  # Output the amount of time it took all tests to run on the current platform
  all_tests_seconds_taken = Time.now().to_f - all_tests_start_time.to_f
  if(all_tests_seconds_taken > 60)
    puts "Time Taken for all tests: " + (all_test_seconds_taken/60).to_s + " minutes"
  else
    puts "Time Taken for all tests: " + (all_tests_seconds_taken).to_s + " seconds"
  end

  # Clean up
  driver.quit
end

