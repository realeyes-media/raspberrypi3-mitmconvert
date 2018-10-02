FROM quay.io/realeyes/rpi3-etcd as etcd

ENV ETCD_BRANCH release-3.3
ENV GOPATH=/go
ENV GOOS=linux
ENV GOARCH=arm
ENV GOARM=7

RUN [ "cross-build-start" ]

RUN etcd --version

RUN [ "cross-build-end" ]


FROM quay.io/realeyes/mitmproxy-rpi3:4.0.3

ENV ETCDCTL_API 3
ENV ETCDCTL_ENDPOINTS http://127.0.0.1:2379

RUN [ "cross-build-start" ]

COPY --from=etcd /usr/local/bin/etcdctl /usr/local/bin/etcdctl

WORKDIR /opt/scripts

COPY entrypoint.sh ./entrypoint.sh
RUN cat entrypoint.sh

COPY cmd.sh ./cmd.sh
RUN cat cmd.sh
RUN chmod +x *.sh

VOLUME /opt/mitmoutput

WORKDIR /opt/mitmoutput

RUN [ "cross-build-end" ]

# Entrypoint runs cmd.sh for launching MITMDump and EtcD remote logger
ENTRYPOINT [ "/opt/scripts/entrypoint.sh" ]

CMD [ "-ns", "/opt/mitmaddons/charles_har_dump.py", "-r", "/opt/mitmoutput/filetoconvert", "--set", "hardump=filetoconvert.har" ]
