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
require 'mechanize'

#WebMock.disable_net_connect!(:allow => 'coveralls.io')

VCR.configure do |c|
  c.cassette_library_dir = "spec/vcr_cassettes"
  c.hook_into :webmock
  c.configure_rspec_metadata!
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def a_delete(path)
  a_request(:delete, TheCity::API::Client::ENDPOINT + path)
end

def a_get(path)
  a_request(:get, TheCity::API::Client::ENDPOINT + path)
end

def a_post(path)
  a_request(:post, TheCity::API::Client::ENDPOINT + path)
end

def a_put(path)
  a_request(:put, TheCity::API::Client::ENDPOINT + path)
end

def stub_delete(path)
  stub_request(:delete, TheCity::API::Client::ENDPOINT + path)
end

def stub_get(path)
  stub_request(:get, TheCity::API::Client::ENDPOINT + path)
end

def stub_post(path)
  stub_request(:post, TheCity::API::Client::ENDPOINT + path)
end

def stub_put(path)
  stub_request(:put, TheCity::API::Client::ENDPOINT + path)
end

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end

def get_oauth_token_for(username, password, subdomain='jasonh')
  agent = Mechanize.new
  agent.request_headers = {'Content-Type' => 'application/json', 'Accept' => 'application/json'}
  auth_response = agent.post("https://authentication.onthecity.org/sessions/login_user_with_oauth",
                             "app_id" => "d0bacdd802d1c792dcd9b4fb906454925112867e7d26797cab9a550da263f7fe",
                             "secret" => "1824354dd21197019ddb29232335170127b57a926815d2be889bdac57f836ac5",
                             "login" => username, "password" => password, "subdomain" => subdomain)
  return JSON.parse(auth_response.body)['access_token']['token']
end

def fire_up_test_client
  ENV['THECITY_SUBDOMAIN'] = 'jasonh'
  client = TheCity::API::Client.new do |config|
    config.app_id        = "d0bacdd802d1c792dcd9b4fb906454925112867e7d26797cab9a550da263f7fe"
    config.app_secret    = "1824354dd21197019ddb29232335170127b57a926815d2be889bdac57f836ac5"
    #config.access_token  = get_oauth_token_for('jhagglund', 'godandman1', 'jasonh')
    config.access_token = '32d04b5fcd5957bcd1294b58c4c1a455640acfb177936da43b883e7346bacc64'
  end
  return client
end
