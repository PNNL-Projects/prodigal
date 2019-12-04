FROM rust:1.39.0-stretch as rust

WORKDIR /app
RUN git clone https://github.com/hurwitzlab/prodigal.git
RUN cd prodigal/run_prodigal && cargo build --release && cp target/release/run_prodigal /usr/local/bin

# prodigal binary
RUN wget --quiet -O /usr/local/bin/prodigal https://github.com/hyattpd/Prodigal/releases/download/v2.6.3/prodigal.linux
RUN chmod +x /usr/local/bin/prodigal

FROM ubuntu:latest
RUN apt-get update -y && apt-get install -y parallel libgomp1
RUN mkdir .parallel && touch .parallel/will-cite
COPY --from=rust /usr/local/bin /usr/local/bin
#COPY --from=rust /usr/local/lib /usr/local/lib
#ENV LD_LIBRARY_PATH /usr/local/lib

# run_prodigal 
CMD ["run_prodigal"]
