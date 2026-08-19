FROM python:3.8-alpine

# Add project source
WORKDIR /musicbot
COPY . ./
COPY ./config sample_config

# Install build dependencies
RUN apk update && apk add --no-cache --virtual .build-deps \
  build-base \
  libffi-dev \
  libsodium-dev

# Install dependencies
RUN apk update && apk add --no-cache \
  ca-certificates \
  ffmpeg \
  opus-dev \
  libffi \
  libsodium \
  gcc \
  git

# Install pip dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

# Upgrade yt-dlp to latest (frequent YouTube bypass fixes)
RUN pip3 install --no-cache-dir -U yt-dlp

# Install official yt-dlp OAuth2 plugin for YouTube auth
RUN pip3 install --no-cache-dir yt-dlp-youtube-oauth2

# Clean up build dependencies
RUN apk del .build-deps

ENV APP_ENV=docker

ENTRYPOINT ["/bin/sh", "docker-entrypoint.sh"]
