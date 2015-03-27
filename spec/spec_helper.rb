require 'coveralls'
require 'database_cleaner'
require 'dm-rspec'
require 'dm-transactions'
require 'fabrication'
require 'faker'
require 'rack/test'
require 'rspec'
require 'simplecov'
require 'support/rack_test_helpers'
require 'capybara/rspec'

ENV['RACK_ENV'] = 'test'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.add_filter "/spec/"
SimpleCov.add_filter do |source_file|
  source_file.lines.count < 3
end

SimpleCov.start

require_relative '../voting.rb'

Capybara.app = Voting::App

# Setup the database in memory
DataMapper.setup(:default, 'sqlite::memory:')
DataMapper.finalize
DataMapper.auto_upgrade!

RSpec.configure do |config|
  config.include(DataMapper::Matchers)
  config.include(RackTestHelpers, :type => :rack)

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
    mocks.verify_doubled_constant_names = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.disable_monkey_patching!

  # Normally I'd run with this on, but datamapper uses instance variables
  # without intializing them quite a bit.
  config.warnings = false

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.profile_examples = 3
  config.order = :random

  Kernel.srand(config.seed)
end
