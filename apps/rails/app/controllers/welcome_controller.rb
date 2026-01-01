class WelcomeController < ActionController::Base
  def index
    render plain: "Hello World from Ruby on Rails!"
  end
end
