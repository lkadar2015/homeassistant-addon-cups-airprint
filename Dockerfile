FROM $BUILD_FROM

LABEL io.hass.version="1.0" io.hass.type="addon" io.hass.arch="aarch64|amd64"

# Set shell
# SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN chmod 755 /usr/bin/dpkg
RUN apt-get update
RUN apt-get install -y --no-install-recommends sudo
RUN apt-get install -y --no-install-recommends locales
RUN apt-get install -y --no-install-recommends avahi-daemon
RUN apt-get install -y --no-install-recommends libnss-mdns
RUN apt-get install -y --no-install-recommends dbus
RUN apt-get install -y --no-install-recommends colord
RUN apt-get install -y --no-install-recommends printer-driver-all
RUN apt-get install -y --no-install-recommends printer-driver-gutenprint
RUN apt-get install -y --no-install-recommends openprinting-ppds
RUN apt-get install -y --no-install-recommends hpijs-ppds
RUN apt-get install -y --no-install-recommends hp-ppd
RUN apt-get install -y --no-install-recommends hplip
RUN apt-get install -y --no-install-recommends printer-driver-foo2zjs
RUN apt-get install -y --no-install-recommends cups-pdf
RUN apt-get install -y --no-install-recommends gnupg2
RUN apt-get install -y --no-install-recommends lsb-release
RUN apt-get install -y --no-install-recommends nano
RUN apt-get install -y --no-install-recommends samba
RUN apt-get install -y --no-install-recommends bash-completion
RUN apt-get install -y --no-install-recommends procps
RUN apt-get clean -y
RUN rm -rf /var/lib/apt/lists/*

COPY rootfs /

# Add user and disable sudo password checking
RUN useradd \
  --groups=sudo,lp,lpadmin \
  --create-home \
  --home-dir=/home/print \
  --shell=/bin/bash \
  --password=$(mkpasswd print) \
  print \
&& sed -i '/%sudo[[:space:]]/ s/ALL[[:space:]]*$/NOPASSWD:ALL/' /etc/sudoers

EXPOSE 631

RUN chmod a+x /run.sh

CMD ["/run.sh"]
