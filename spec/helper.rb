require 'simplecov'
require 'coveralls'
Coveralls.wear!

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start

require 'the_city'
require 'rspec'
require 'webmock/rspec'
require 'vcr'
require 'typhoeus'
require 'active_support/core_ext'

VCR.configure do |c|
  c.cassette_library_dir = "spec/vcr_cassettes"
  c.hook_into :webmock
  c.default_cassette_options = {:re_record_interval => 7.days}
  c.configure_rspec_metadata!
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def fire_up_test_client(username, password, subdomain)
  ENV['THECITY_SUBDOMAIN'] = subdomain
  client = TheCity::API::Client.new do |config|
    config.app_id        = ''
    config.app_secret    = ''
    config.access_token  = ''
  end
  return client
end

#def a_delete(path)
#  a_request(:delete, TheCity::API::Client::ENDPOINT + path)
#end
#
#def a_get(path)
#  a_request(:get, TheCity::API::Client::ENDPOINT + path)
#end
#
#def a_post(path)
#  a_request(:post, TheCity::API::Client::ENDPOINT + path)
#end
#
#def a_put(path)
#  a_request(:put, TheCity::API::Client::ENDPOINT + path)
#end
#
#def stub_delete(path)
#  stub_request(:delete, TheCity::API::Client::ENDPOINT + path)
#end
#
#def stub_get(path)
#  stub_request(:get, TheCity::API::Client::ENDPOINT + path)
#end
#
#def stub_post(path)
#  stub_request(:post, TheCity::API::Client::ENDPOINT + path)
#end
#
#def stub_put(path)
#  stub_request(:put, TheCity::API::Client::ENDPOINT + path)
#end
#
#def fixture_path
#  File.expand_path("../fixtures", __FILE__)
#end
#
#def fixture(file)
#  File.new(fixture_path + '/' + file)
#end