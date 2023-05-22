FROM debian:buster-slim as builder

RUN apt-get update \
  && apt-get -y install \
    build-essential \
    cmake \
    libzmq3-dev \
    libzmq5 \
    git

WORKDIR /root
RUN git clone --recursive https://github.com/Knifa/led-matrix-zmq-server.git
WORKDIR /root/led-matrix-zmq-server/rpi-rgb-led-matrix
RUN git checkout master

WORKDIR /root/led-matrix-zmq-server/rpi-rgb-led-matrix/lib
RUN make

WORKDIR /root/led-matrix-zmq-server
RUN make

FROM debian:buster-slim

WORKDIR /root

RUN apt-get update \
  && apt-get -y install \
    libzmq5

COPY --from=builder /root/led-matrix-zmq-server/bin/led-matrix-zmq-server ./led-matrix-zmq-server
RUN chmod +x ./led-matrix-zmq-server

EXPOSE 42042/tcp
ENTRYPOINT ["/root/led-matrix-zmq-server"]
