# Use the official lightweight Ruby image.
# https://hub.docker.com/_/ruby
FROM ruby:2.6.6 AS rails-toolbox

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install -y curl gnupg2 && \
    curl -sS https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
    echo "deb https://deb.nodesource.com/node_14.x buster main" > /etc/apt/sources.list.d/nodesource.list && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -y nodejs yarn libpq-dev python3-distutils

# Set up the application directory
WORKDIR /app

# Install bundler and production dependencies
COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v 2.4.22
RUN bundle config set --local deployment 'true' && \
    bundle config set --local without 'development test' && \
    bundle install

# Copy the application code to the container image
COPY . .

# Set environment variables
ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true
ENV SECRET_KEY_BASE=<YOUR_SECRET_KEY_BASE>

# Precompile assets and run database migrations
RUN bundle exec rake assets:precompile
RUN bundle exec rake db:create
RUN bundle exec rake db:migrate
RUN bundle exec rake db:seed

# Expose port 8080
EXPOSE 8080

# Start Rails server
CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "8080"]

