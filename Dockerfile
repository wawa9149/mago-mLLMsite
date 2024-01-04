# Environemnt to install flutter and build web
FROM debian:latest AS build-env

# install all needed stuff
#RUN apt-get update
#RUN apt-get install -y curl git unzip
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y curl git wget unzip fonts-droid-fallback sed tar xz-utils zip locales
RUN apt-get clean
RUN locale-gen ko_KR.UTF-8

# define variables
ARG FLUTTER_SDK=/usr/local/flutter
ARG APP=/app/

#clone flutter
RUN git clone https://github.com/flutter/flutter.git $FLUTTER_SDK
# change dir to current flutter folder and make a checkout to the specific version
RUN cd $FLUTTER_SDK && git checkout efbf63d9c66b9f6ec30e9ad4611189aa80003d31


#ADD flutter /usr/local/
# setup the flutter path as an enviromental variable
ENV PATH="$FLUTTER_SDK/bin:$FLUTTER_SDK/bin/cache/dart-sdk/bin:${PATH}"

# Start to run Flutter commands
# doctor to see if all was installes ok
RUN flutter doctor -v
RUN flutter channel master
RUN flutter upgrade
RUN flutter config --enable-web

# create folder to copy source code
RUN mkdir $APP
# copy source code to folder
COPY . $APP
# stup new folder as the working directory
WORKDIR $APP

# Run build: 1 - clean, 2 - pub get, 3 - build web
RUN flutter clean
RUN flutter pub get
RUN flutter build web

# once heare the app will be compiled and ready to deploy

# use nginx to deploy
FROM nginx

# copy the info of the builded web app to nginx
COPY --from=build-env /app/build/web /usr/share/nginx/html

ENV LANG ko_KR.UTF-8
ENV LANGUAGE ko_KR:ko
ENV LC_ALL ko_KR.UTF-8

# Expose and run nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]