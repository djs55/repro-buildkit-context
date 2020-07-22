FROM alpine

COPY . /foo
RUN rm -rf /foo/.git
WORKDIR /foo
CMD find .
