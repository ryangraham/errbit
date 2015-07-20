FROM phusion/passenger-ruby22
MAINTAINER Ryan Graham <ryangraham@gmail.com>

RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -y -o Dpkg::Options::="--force-confold" nginx-extras passenger
RUN apt-get -y upgrade

RUN rm -f /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default
ADD errbit.conf /etc/nginx/sites-enabled/errbit.conf
ADD rails-env.conf /etc/nginx/main.d/rails-env.conf

ADD entrypoint.sh /tmp/entrypoint.sh
RUN chmod a+x /tmp/entrypoint.sh

RUN /usr/sbin/useradd errbit
ADD https://github.com/errbit/errbit/archive/v0.4.0.tar.gz /tmp/
RUN tar -zxvf /tmp/v0.4.0.tar.gz -C /opt
RUN ln -s /opt/errbit-0.4.0 /opt/errbit
RUN chown -R errbit:errbit /opt/errbit-0.4.0
USER errbit
WORKDIR /opt/errbit

ENV RAILS_ENV production
RUN bundle install --deployment
RUN bundle exec rake assets:precompile

USER root
ENTRYPOINT ["/tmp/entrypoint.sh"]
EXPOSE 80
CMD ["/sbin/my_init"]
