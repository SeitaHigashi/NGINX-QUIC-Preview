FROM    ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y git mercurial golang ninja-build make cmake perl gcc libpcre3 libpcre3-dev zlib1g-dev && \
    git clone https://boringssl.googlesource.com/boringssl && \
    mkdir boringssl/build && \
    cd boringssl/build && \
    cmake -GNinja .. && \
    ninja && \
    cd ../../ && \
    hg clone -b quic https://hg.nginx.org/nginx-quic && \
    cd nginx-quic && \
    ./auto/configure --with-debug --with-http_v3_module --with-cc-opt="-I../boringssl/include" --with-ld-opt="-L../boringssl/build/ssl -L../boringssl/build/crypto" && \
    make

CMD [ "/usr/local/nginx/sbin/nginx", "-g", "deamon off;" ]