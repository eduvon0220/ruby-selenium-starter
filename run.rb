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

desktop_cap_list = DESKTOP_CAP_LIST_CONFIGS

mobile_cap_list = MOBILE_CAP_LIST_CONFIGS

desired_cap_list = []

if (options[:desktop])
  # if the desktop argument has been passed, then only run the desktop tests
  desired_cap_list += desktop_cap_list
end

if (options[:mobile])
  # if the mobile argument has been passed, then only run the mobile tests
  desired_cap_list += mobile_cap_list
end

if (desired_cap_list.empty?)
  # if no desktop or mobile argument has been passed, then run both the desktop and mobile tests
  desired_cap_list = desktop_cap_list + mobile_cap_list
end
# if a specific filter arg was set via the command line, remove anything from the desired_capabilities list that does not meet the requirement
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

puts options
puts desired_cap_list

# Get base url from config file
# Get desktop_cap_array from config file
# Get mobile_cap_array from config file
