# Set up all the configuration variables needed for run.rb
DEFAULT_BASE_URL = "http://www.google.com" # set this

# This has been set as an array so that we can set multiple environments and run the tests below in a for loop
# to repeat the tests for different operating systems. I have set a mobile capability list and
# desktop capability list to allow the use of either or with a flag. More tests can easily be added. See the
# browser stack website to get more options.
# The below tests IE8, IE9, IE10 and IE11 on windows and then chrome, safari and Firefox on a Mac. Pay attention to
# the version numbers.
DESKTOP_CAP_LIST_CONFIGS = [
    {browser:'IE',browser_version: '8.0', os: 'Windows', os_version: '7', resolution: '1024x768'},
    {browser: 'IE', browser_version: '9.0', os: 'Windows', os_version: '7', resolution: '1024x768'},
    {browser: 'IE', browser_version: '10.0', os: 'Windows', os_version: '7', resolution: '1024x768'},
    {browser: 'IE', browser_version: '11.0', os: 'Windows', os_version: '7', resolution: '1024x768'},
    {browser: 'Chrome', browser_version: '39.0', os: 'OS X', os_version: 'Yosemite',
     resolution: '1024x768'},
    {browser: 'Firefox', browser_version: '35.0', os: 'OS X', os_version: 'Yosemite',
     resolution: '1024x768'},
    # Safari is not well supported by selenium
    # {browser: 'Safari', browser_version: '8.0', os: 'OS X', os_version: 'Yosemite',
    #  resolution: '1024x768'},
]

# The below tests an iPhone 5 and Samsung Galaxy S5.
MOBILE_CAP_LIST_CONFIGS = [
    # {browserName: 'iPhone', platform: 'MAC', device: 'iPhone 5'},
    # {browserName: 'android', platform: 'ANDROID', device: 'Samsung Galaxy S5'},
]
