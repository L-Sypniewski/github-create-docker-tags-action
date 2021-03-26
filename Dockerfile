FROM ubuntu:20.04

LABEL "repository"="https://github.com/L-Sypniewski/github-create-docker-tags-action"
LABEL "homepage"="https://github.com/aL-Sypniewski/github-create-docker-tags-action"
LABEL "maintainer"="Łukasz Sypniewski"

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
