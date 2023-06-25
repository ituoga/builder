FROM hashicorp/terraform:latest
RUN apk update && apt add ansible bash

