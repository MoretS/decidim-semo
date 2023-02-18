FROM ruby:3.0.2

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV RAILS_ENV production
ENV PORT 3000
ENV SECRET_KEY_BASE=no_need_for_such_secrecy
ENV RAILS_SERVE_STATIC_FILES=true

RUN apt-get install -y git imagemagick wget \
    && apt-get clean

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean

RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y yarn \
    && apt-get clean

RUN npm install -g npm@8.19.2

RUN gem install bundler --version '>= 2.3.20'

WORKDIR /code
COPY . .

RUN bundle install
RUN yarn install
RUN bundle exec rails assets:precompile

ENTRYPOINT []

CMD bundle exec rails s -b 0.0.0.0 -p $PORT
