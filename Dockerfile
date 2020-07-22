FROM alpine

COPY . /foo
WORKDIR /foo
CMD find .
