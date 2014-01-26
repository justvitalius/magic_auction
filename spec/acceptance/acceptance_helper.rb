require 'spec_helper'

require 'database_cleaner'

require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

RSpec.configure do |config|

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end


  config.include Features::SelectDatesAndTimesHelper, type: :feature
  config.include Features::SessionsHelper, type: :feature


  # autosave errors screenshots
  # source http://viget.com/extend/auto-saving-screenshots-on-test-failures-other-capybara-tricks
  config.after(:each) do
    if example.exception && example.metadata[:js]
      meta = example.metadata
      filename = File.basename(meta[:file_path])
      line_number = meta[:line_number]
      screenshot_name = "screenshot-#{filename}-#{line_number}.png"
      screenshot_path = "#{Rails.root.join("test_images")}/#{screenshot_name}"

      page.save_screenshot(screenshot_path, full: true)

      puts meta[:full_description] + "\n  Screenshot: #{screenshot_path}"
    end
  end

end


