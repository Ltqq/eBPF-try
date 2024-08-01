FROM golang:1.22.1-alpine3.18-amd64 as builder

COPY ./ /workdir

WORKDIR /workdir

RUN go build -gcflags="all=-N -l" -o webapp ./main.go


FROM alpine:3.18

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && apk add --no-cache \
    clang \
    llvm \
    elfutils-dev \
    gcc \
    make \
    iproute2 \
    bcc-tools \
    linux-headers \
    iputils \
    iproute2 \
    python3 \
    py3-pip \
    bash

RUN pip3 install bcc

COPY --from=builder /workdir/webapp /usr/local/bin/webapp
COPY --from=builder /workdir/trace.py /usr/local/bin/trace.py
COPY --from=builder /workdir/start.sh /usr/local/bin/start.sh

CMD ["/usr/local/bin/start.sh"]
