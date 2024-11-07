
RSpec.configure do |config|
  config.include Capybara::DSL, type: :feature
  config.include Capybara::RSpecMatchers, type: :feature

  Capybara.default_driver = :rack_test
  Capybara.javascript_driver = :selenium_chrome

  Capybara.register_driver :selenium_chrome do |app|
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless') unless ENV['CAPYBARA_HEADLESS'] == 'false'
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-dev-shm-usage')

    Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      options: options
    )
  end

  config.use_transactional_fixtures = false

  config.before(:suite) do
    raise(<<-MSG) if config.use_transactional_fixtures?
          Delete line `config.use_transactional_fixtures = true` from rails_helper.rb
          (or set it to false) to prevent uncommitted transactions being used in
          JavaScript-dependent specs.

          During testing, the app-under-test that the browser driver connects to
          uses a different database connection to the database connection used by
          the spec. The app's database connection would not be able to access
          uncommitted transaction data setup over the spec's database connection.
        MSG
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) { DatabaseCleaner.strategy = :transaction }

  config.before(:each, type: :feature) do
    # :rack_test driver's Rack app under test shares database connection
    # with the specs, so continue to use transaction strategy for speed.
    driver_shares_db_connection_with_specs =
      Capybara.current_driver == :rack_test

    unless driver_shares_db_connection_with_specs
      # Driver is probably for an external browser with an app
      # under test that does *not* share a database connection with the
      # specs, so use truncation strategy.
      DatabaseCleaner.strategy = :truncation
    end
  end

  config.before(:each) { DatabaseCleaner.start }

  config.append_after(:each) { DatabaseCleaner.clean }

  config.before(:each, type: :system) do
    driven_by :selenium_chrome
  end

  config.before(:each, type: :system, js: true) do
    driven_by :selenium_chrome
  end
end
