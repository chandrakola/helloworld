require 'test/unit'
require 'rack/test'
require_relative '../../config/environment'

class WelcomeControllerTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Rails.application
  end

  def test_homepage
    get '/'
    assert last_response.ok?
    assert last_response.body.include?('Hello World from Ruby on Rails!')
  end
end
