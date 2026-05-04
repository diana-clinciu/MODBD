FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV FLUTTER_HOME=/opt/flutter
ENV PATH=$FLUTTER_HOME/bin:$FLUTTER_HOME/bin/cache/dart-sdk/bin:$PATH

RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/flutter/flutter.git -b stable --depth 1 $FLUTTER_HOME \
    && flutter precache --web \
    && flutter config --enable-web \
    && flutter --version

WORKDIR /app

EXPOSE 8080

CMD ["bash", "-c", "flutter pub get && flutter run -d web-server --web-hostname=0.0.0.0 --web-port=8080"]
