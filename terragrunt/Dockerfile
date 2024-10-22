ARG TERRAFORM_VERSION=latest
FROM alpine/terragrunt:$TERRAFORM_VERSION
RUN apk add vim bash git python3
RUN mkdir -p /app/terragrunt
COPY scripts/docker.bashrc /root/.bashrc
WORKDIR /app/terragrunt
ENTRYPOINT ["/bin/bash"]
