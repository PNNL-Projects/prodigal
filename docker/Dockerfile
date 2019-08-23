#FROM ubuntu:latest
FROM rust:1.37.0-stretch

WORKDIR /app

RUN apt-get update -y
RUN apt-get install parallel wget libterm-readline-gnu-perl -y #build-essential curl
#RUN curl -sSf sh.rustup.rs | sh -s -- -y
#RUN echo "export PATH=~/.cargo/bin:$PATH" >> ~/.bashrc
RUN mkdir .parallel && touch .parallel/will-cite

ENV PATH=/app:$PATH

# prodigal binary
RUN wget --quiet -O /app/prodigal https://github.com/hyattpd/Prodigal/releases/download/v2.6.3/prodigal.linux
RUN chmod +x /app/prodigal

# run_prodigal 
RUN git clone https://github.com/hurwitzlab/prodigal.git
RUN cd prodigal/run_prodigal && cargo build && cp target/debug/run_prodigal /usr/local/bin

CMD ["run_prodigal"]

#ENTRYPOINT ["prodigal"]
