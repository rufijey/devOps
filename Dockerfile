FROM alpine
WORKDIR /home/classaimage
COPY ./classa .
RUN apk add libstdc++
RUN apk add libc6-compat
ENTRYPOINT ["./classa"]

