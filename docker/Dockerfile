FROM ubuntu:latest

WORKDIR /app

RUN apt-get update -y
RUN apt-get install git parallel wget libterm-readline-gnu-perl -y 
RUN mkdir .parallel && touch .parallel/will-cite

ENV PATH=/app:$PATH

# prodigal binary
RUN wget --quiet -O /usr/local/bin/prodigal https://github.com/hyattpd/Prodigal/releases/download/v2.6.3/prodigal.linux
RUN chmod +x /usr/local/bin/prodigal

# run_prodigal 
RUN git clone https://github.com/hurwitzlab/prodigal.git
RUN cp prodigal/bin/run_prodigal /usr/local/bin

CMD ["run_prodigal"]

#ENTRYPOINT ["prodigal"]
