FROM debian:buster-slim
ARG DEBIAN_FRONTEND=noninteractive
COPY entrypoint.sh openwb-docker-install.sh /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN /openwb-docker-install.sh
ENTRYPOINT ["/entrypoint.sh"]
