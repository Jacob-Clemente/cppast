# Build Stage
FROM --platform=linux/amd64 ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y cmake

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y g++

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y libclang-dev

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y git

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y llvm

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y clang

## Add source code to the build stage.
ADD . /cppast
WORKDIR /cppast/build

## TODO: ADD YOUR BUILD INSTRUCTIONS HERE.
RUN cmake ..
RUN make

#Package Stage
FROM --platform=linux/amd64 ubuntu:20.04

## TODO: Change <Path in Builder Stage>
COPY --from=builder /cppast/build/tool/cppast /
COPY --from=builder /usr/lib/x86_64-linux-gnu/libclang-10.so.1 /usr/lib/x86_64-linux-gnu/libclang-10.so.1

COPY --from=builder /usr/lib/x86_64-linux-gnu/libLLVM-10.so /usr/lib/x86_64-linux-gnu/libLLVM-10.so

COPY --from=builder /usr/lib/x86_64-linux-gnu/libLLVM-10.so.1 /usr/lib/x86_64-linux-gnu/libLLVM-10.so.1

COPY --from=builder /usr/lib/x86_64-linux-gnu/libedit.so.2 /usr/lib/x86_64-linux-gnu/libedit.so.2

COPY --from=builder /usr/lib/x86_64-linux-gnu/libbsd.so.0 /usr/lib/x86_64-linux-gnu/libbsd.so.0


