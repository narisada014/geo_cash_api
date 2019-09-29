FROM ruby:2.6.4

ENV LANG C.UTF-8

RUN apt-get update && \
    apt-get install -y build-essential default-mysql-client sudo git mecab libmecab-dev mecab-ipadic-utf8 --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git \
    && cd mecab-ipadic-neologd \
    && bin/install-mecab-ipadic-neologd -n -y

RUN mkdir /app

WORKDIR /app

ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock

RUN gem update --system

RUN gem install bundler
RUN bundle install

#ADD package.json /app/package.json
#ADD yarn.lock /app/yarn.lock
#
#RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash - && \
#    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && \
#    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && \
#    apt update -y && \
#    apt install -y nodejs yarn build-essential && \
#    yarn

ADD . /app

