require 'selenium-webdriver'
require 'optparse'

options = {}

opt_parser = OptionParser.new do |opts|
  opts.banner = "Usage: run.rb [options]"

  opts.on("--desktop", "(boolean) Make the tests only run tests on desktop computers.") do |d|
    options[:desktop] = d
  end

  opts.on("--mobile", "(boolean) Make the tests only run tests on mobile devices.")   do |m|
    options[:mobile] = m
  end

  opts.on("--use_local", "(boolean) Use the local Browserstack selenium testing.")    do |l|
    options[:use_local] = l
  end

  opts.on("--base_url x", "A way to override the DEFAULT_BASE_URL for your tests.") do |base_url|
    options[:base_url] = base_url
  end

  opts.on("--test", "Only run one test as specified") do |t|
    options[:test] = t
  end

  desired_cap_config_notes = " The available values you can pass to this command will depend on the values you have set in your config.rb file"

  opts.on("--browser", "Desktop: Only run tests on the given browser." + desired_cap_config_notes) do |b|
    options[:browser] = b
  end

  opts.on("--browser_version", "Desktop: Only run tests on the given browser version." + desired_cap_config_notes) do |b|
    options[:browser_version] = b
  end

  opts.on("--os", "Desktop: Only run tests on the given operating system." + desired_cap_config_notes) do |o|
    options[:os] = o
  end

  opts.on("--os_version", "Desktop: Only run tests on the given operating system version." + desired_cap_config_notes) do |o|
    options[:os_version] = o
  end

  opts.on("--resolution", "Desktop: Only run tests on the given screen resolution." + desired_cap_config_notes) do |r|
    options[:resolution] = r
  end

  opts.on("--browserName", "Mobile: Only run tests on the given mobile browser name." + desired_cap_config_notes) do |b|
    options[:browser_name] = b
  end

  opts.on("--platform", "Mobile: Only run tests on the given mobile platforms." + desired_cap_config_notes) do |p|
    options[:platform] = p
  end

  opts.on("--device", "Mobile: Only run tests on the given mobile device." + desired_cap_config_notes) do |d|
    options[:device] = d
  end

  opts.on("--capabilities", "Example: \"{'browser': 'IE', 'browser_version': '8.0', 'os': 'Windows', " + "'os_version': '7', 'resolution': '1024x768'}\" Can be used as an alternative to adding many of" + "the arguments above such as mobile, desktop, browser, browser_version, etc.") do |c|
    options[:capabilities] = c
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

if (options[:capabilities])
  # if the user passed --capabilities "{...}" that that will be the only platform tested on 
  # convert the string into a ruby hash so it can be used in as a desired capability
end

puts options
