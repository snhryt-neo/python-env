FROM python:3.7.6-slim as builder
WORKDIR /usr/local
COPY requirements.txt /usr/local
RUN pip install -U pip \
  && pip install -r requirements.txt

FROM python:3.7.6-slim as runner
ARG package_dir="/usr/local/lib/python3.7/site-packages"
COPY --from=builder $package_dir $package_dir
RUN apt-get update \
  && apt-get install -qqy git curl less vim libopencv-dev gnupg

# Chrome browser and driver for Selenium
RUN curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add
RUN echo "deb [arch=amd64]  http://dl.google.com/linux/chrome/deb/ stable main" \
  >> /etc/apt/sources.list.d/google-chrome.list
RUN apt-get update \
  && apt-get install -qqy google-chrome-stable unzip
RUN curl -OL https://chromedriver.storage.googleapis.com/89.0.4389.23/chromedriver_linux64.zip \
  && unzip chromedriver_linux64.zip chromedriver \
  && mv chromedriver /usr/bin/chromedriver

RUN apt-get update \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN mv /root/.bashrc /root/.bashrc_origin
COPY .bashrc /root/
