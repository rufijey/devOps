FROM alpine AS build

RUN apk add --no-cache build-base automake autoconf git

WORKDIR /home/classaimage
RUN git clone --branch branchHTTPservMulti https://github.com/rufijey/devOps.git .

RUN autoreconf -fi
RUN ./configure
RUN make

FROM alpine
COPY --from=build /home/classaimage/classa /usr/local/bin/classa

ENTRYPOINT ["/usr/local/bin/classa"]
