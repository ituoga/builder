FROM hashicorp/terraform:latest
RUN apk update && apk add ansible bash

