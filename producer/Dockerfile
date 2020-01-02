ARG PYTHON_VERSION=3.7-alpine3.11

FROM python:$PYTHON_VERSION

WORKDIR /app

RUN apk add --no-cache \
    bash \
    curl \
    g++ \
    gcc \
    git \
    libffi-dev \
    lsof \
    musl-dev \
    openssh \
    librdkafka-dev


COPY requirements.txt .

RUN apk add --no-cache --virtual build-dependencies \
    abuild \
    binutils \
    build-base \
    linux-headers \
    zlib-dev \
    && RDKAFKA_INSTALL=system pip install -r requirements.txt \
    && apk del build-dependencies

COPY . .

CMD [ "python", "app.py" ]
