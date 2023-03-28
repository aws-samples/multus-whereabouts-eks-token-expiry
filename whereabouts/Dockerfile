FROM ubuntu:jammy

RUN apt-get update && apt-get install curl -y && \
    curl -LO https://dl.k8s.io/release/v1.24.0/bin/linux/amd64/kubectl && chmod +x kubectl && mv kubectl /usr/local/bin/

COPY eks-token-renew-hourly.sh .

RUN chmod +x eks-token-renew-hourly.sh