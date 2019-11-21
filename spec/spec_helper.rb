RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  lib_dir = File.expand_path('../lib', __dir__)
  $LOAD_PATH.unshift lib_dir
  Dir["#{lib_dir}/**/*.rb"].each { |file| require File.basename(file) }
end
