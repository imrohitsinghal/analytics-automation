# hasStarted = nil
After do |scenario|
  if scenario.failed?
    tags = scenario.source_tag_names.map(&:downcase).map{|x| x.gsub('@','')}
    unless tags.include?("non-gui") || tags.include?("nongui")
      encoded_img = page.driver.browser.screenshot_as(:base64)
      embed("data:image/png;base64,#{encoded_img}", 'image/png', "----- SCREENSHOT OF THE SCENARIO -----")
    end
  end
  puts "ending scenario"
end

Before ('@setup_mitm_proxy')do
  sleep 50
  $hasStarted = spawn("./start-mitm.sh")
  # Process.detach(pid)
  if($hasStarted)
    puts "mitm setup successfully"
  end
end

Before do
  if ENV['BROWSER'] == 'firefox' || ENV['BROWSER'] == 'headless-firefox'
    Capybara.page.driver.browser.manage.window.maximize
  end
end

at_exit do
  require 'rspec'
  spawn("./kill-process.sh")
  include RSpec::Matchers

  # if ENV['security'] == 'true'
  #   response = JSON.parse RestClient.get "#{$zap_proxy}:#{$zap_port}/json/core/view/alerts"
  #   events = response['alerts']
  #   events.each { |x| p x }
  #   high_risks = events.select{|x| x['risk'] == 'High'}
  #   high_count = high_risks.size
  #   medium_count = events.select{|x| x['risk'] == 'Medium'}.size
  #   low_count = events.select{|x| x['risk'] == 'Low'}.size
  #   informational_count = events.select{|x| x['risk'] == 'Informational'}.size
  #   puts "HC: #{high_count}, MC: #{medium_count}, LC: #{low_count}, IC: #{informational_count}"
  #
  #   if high_count > 0
  #     high_risks.each { |x| p x['alert'] }
  #   end
  #
  #   expect(high_count).to eq 0
    # Process.detach($hasStarted)
  # end
end