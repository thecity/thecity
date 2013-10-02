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

APP_ID = "aee1e51abe07366e3a11d4dfc0f95e17d58a1e3c45a8d3016c8a427459ba2a3b"
SECRET = "7cc1c16604a021b43ce5b49a2c2fb808c23b33d998e76ca866475a5a8ca44a04"

def get_oauth_token_for(username, password, subdomain='jasonh')
  auth_response = Typhoeus.post("https://authentication.onthecity.org/sessions/login_user_with_oauth",
                :params => {"app_id" => APP_ID, "secret" => SECRET, "login" => username, "password" => password, "subdomain" => subdomain})
  typhoeus_token = JSON.parse(auth_response.options[:response_body])['access_token']['token'] rescue nil
  vcr_token = JSON.parse(auth_response.options[:body])['access_token']['token'] rescue nil
  if typhoeus_token.nil?
    return vcr_token
  else
    return typhoeus_token
  end
end

def fire_up_test_client(subdomain='jasonh')
  ENV['THECITY_SUBDOMAIN'] = subdomain
  client = TheCity::API::Client.new do |config|
    config.app_id        = APP_ID
    config.app_secret    = SECRET
    config.access_token  = get_oauth_token_for('jhagglund', 'godandman1', subdomain)
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