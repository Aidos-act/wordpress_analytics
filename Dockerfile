FROM ruby:2.5.5
ENV LANG C.UTF-8

# install essential libraries
RUN apt-get update -qq && \
    apt-get upgrade -y && \
    apt-get install -y build-essential vim cron locales && \
    rm -rf /var/lib/apt/lists/* && \
    echo "ja_JP.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen ja_JP.UTF-8

# yarn package manager install
RUN apt-get update && apt-get install -y --no-install-recommends curl apt-transport-https wget && \
  	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  	echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  	apt-get update && apt-get install -y --no-install-recommends yarn && \
    gem install bundler

# nodejs install
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install -y --no-install-recommends nodejs && rm -rf /var/lib/apt/lists/*


ENV LC_ALL ja_JP.UTF-8
ENV TZ Asia/Tokyo

ENV WORKSPACE=/app

RUN mkdir -p $WORKSPACE
WORKDIR $WORKSPACE

COPY Gemfile ./Gemfile
COPY Gemfile.lock ./Gemfile.lock

RUN bundle install

COPY . $WORKSPACE

# Create empty crontab file & whenever update
RUN gem install whenever && \
    crontab -l | { cat; echo ""; } | crontab - && \
    bundle exec whenever --update-crontab

CMD ["cron", "-f"]


# CMD bash -c "service cron start && cron -f"
# Run service cron start
