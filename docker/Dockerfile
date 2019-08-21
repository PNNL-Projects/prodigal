FROM ubuntu:latest

WORKDIR /app

RUN apt-get update -y
RUN apt-get install wget libterm-readline-gnu-perl -y
ENV PATH=/app:$PATH

RUN wget --quiet -O /app/prodigal https://github.com/hyattpd/Prodigal/releases/download/v2.6.3/prodigal.linux


RUN chmod +x /app/prodigal

RUN ls -lh /app

CMD ["prodigal"]
#ENTRYPOINT ["prodigal"]
