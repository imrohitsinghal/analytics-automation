#encoding: UTF-8
require 'cucumber'
require 'rspec'
require 'selenium-webdriver'
require 'capybara'
require 'capybara/dsl'
require 'rest-client'
require 'pdf-reader'
require 'xmlsimple'
require 'net/sftp'

$environment = "pp"
if ENV['environment']
  $environment = ENV['environment']
end

browser = ENV['BROWSER']
Capybara.register_driver :selenium do |app|
  browser = ENV['BROWSER']
  if browser == "firefox"
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile["network.http.phishy-userpass-length"] = "255"
    options = Selenium::WebDriver::Firefox::Options.new(profile: profile)
    capabilities = { acceptInsecureCerts: true }
    # noinspection RubyArgCount
    Capybara::Selenium::Driver.new(app, browser: :firefox, options: options, desired_capabilities: capabilities)
  elsif browser == "headless-firefox"
    ENV['MOZ_HEADLESS'] = '1'
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile["network.http.phishy-userpass-length"] = "255"
    options = Selenium::WebDriver::Firefox::Options.new(profile: profile)
    capabilities = { acceptInsecureCerts: true }
    # noinspection RubyArgCount
    Capybara::Selenium::Driver.new(app, browser: :firefox, options: options, desired_capabilities: capabilities)
  elsif browser == "headless-chrome"
    arguments = ["headless","disable-gpu", "no-sandbox", "window-size=1920,1080", "privileged", "ignore-certificate-errors"]
    preferences = {
        'download.default_directory': File.expand_path(File.join(File.dirname(__FILE__), "../../downloads/")),
        'download.prompt_for_download': false,
        'plugins.plugins_disabled': ["Chrome PDF Viewer"],
    }
    options = Selenium::WebDriver::Chrome::Options.new(args: arguments, prefs: preferences)
    # noinspection RubyArgCount
    Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
  elsif browser == "sauce"
    capabilities = {
        version: '11.0',
        browserName: 'Internet Explorer',
        platform: 'Windows 7',
        screenResolution: "1920x1080",
        tunnelIdentifier: ENV['SAUCE_TUNNEL_NAME']
    }
    url = "https://#{ENV['SAUCE_USER']}:#{ENV['SAUCE_PASSWORD']}@ondemand.saucelabs.com:443/wd/hub".strip

    Capybara::Selenium::Driver.new(app,
                                   browser: :remote,
                                   url: url,
                                   desired_capabilities: capabilities)
  else
    arguments = ["window-size=1920,1080", "ignore-certificate-errors"]
    preferences = {
        'download.default_directory': File.expand_path(File.join(File.dirname(__FILE__), "../../downloads/")),
        'download.prompt_for_download': false,
        'plugins.plugins_disabled': ["Chrome PDF Viewer"]
    }
    options = Selenium::WebDriver::Chrome::Options.new(args: arguments, prefs: preferences)
    # noinspection RubyArgCount
    Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
  end
end

if ENV['security'] == 'true'
  Capybara.register_driver :selenium do |app|
    $zap_proxy = ENV['zap_proxy']
    $zap_port = ENV['zap_port']
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile["network.http.phishy-userpass-length"] = "255"
    # profile["network.proxy.type"] = 1
    # profile["network.proxy.http"] = $zap_proxy
    # profile["network.proxy.http_port"] = $zap_port
    caps = Selenium::WebDriver::Remote::Capabilities.firefox(proxy: Selenium::WebDriver::Proxy.new(http: "#{$zap_proxy}:#{$zap_port}"))

    options = Selenium::WebDriver::Firefox::Options.new(profile: profile)
    # noinspection RubyArgCount
    Capybara::Selenium::Driver.new(app, browser: :firefox, options: options, desired_capabilities: caps)
  end
end

Capybara.run_server = false
Capybara.default_driver = :selenium
Capybara.javascript_driver = :selenium
Capybara.default_selector = :css
Capybara.default_max_wait_time = 20
# Capybara.ignore_hidden_elements = false

Capybara.app_host = 'http://www.google.com'

World(Capybara::DSL)
puts "running on browser: #{browser}"

puts Capybara.server_port