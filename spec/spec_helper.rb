require 'rspec'
require 'rack/test'
require './app'

module SinatraTest
  def app
    Sinatra::Application
  end

  def post_text(text)
    post '/', text: text
  end

  def response_text
    JSON.parse(last_response.body)["text"]
  end
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include SinatraTest
end

