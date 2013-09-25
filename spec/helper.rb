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

WebMock.disable_net_connect!(:allow => 'coveralls.io')

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
