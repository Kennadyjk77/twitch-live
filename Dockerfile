FROM ubuntu:22.04

RUN apt-get update && apt-get install -y ffmpeg curl python3 python3-pip && pip3 install gdown

WORKDIR /app

COPY run.sh /app/run.sh
RUN chmod +x /app/run.sh

CMD ["/app/run.sh"]
