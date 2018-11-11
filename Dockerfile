FROM ruby:2.5.0

RUN apt-get update && apt-get install -y build-essential libpq-dev postgresql-client
RUN gem install rails
RUN mkdir rhizm
WORKDIR rhizm
COPY Gemfile /rhizm/Gemfile
COPY Gemfile.lock /rhizm/Gemfile.lock
RUN bundle install
