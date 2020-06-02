FROM ruby:2.5.5

RUN apt-get update -qq && \
    apt-get upgrade -y && \
    apt-get install -y build-essential

# yarn and nodejs for webpacker
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
  	&& apt-get install -y nodejs  

RUN apt-get update && apt-get install -y curl apt-transport-https wget && \
  	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  	echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  	apt-get update && apt-get install -y yarn && \
  	gem install bundler

RUN yarn install --check-files

ENV WORKSPACE=/analytics_app
ENV LANG C.UTF-8

RUN mkdir -p $WORKSPACE
WORKDIR $WORKSPACE

COPY Gemfile* ./

RUN bundle install

COPY . $WORKSPACE

RUN gem install foreman



# RUN yarn upgrade && \
#	gem install foreman

# RUN mkdir -p tmp/sockets
# EXPOSE 3000

# ENTRYPOINT ["docker-entrypoint.sh"]

# Start the main process.
# CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
# CMD foreman start -f Procfile ??