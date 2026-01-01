FROM ruby:3.2

WORKDIR /app

COPY Gemfile ./
RUN bundle install

COPY . .

# Run unit tests
RUN bundle exec ruby -I lib:test test/controllers/welcome_controller_test.rb

EXPOSE 8003

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "--port", "8003"]
