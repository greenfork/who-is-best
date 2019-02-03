FROM ruby:2.6.1

RUN apt-get update \
    && apt-get install -y \
       sqlite3 \
       nodejs

RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 3000

CMD ["rails", "server"]
