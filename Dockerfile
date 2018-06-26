FROM lowyard/busybox-curl:latest as build
ENV VER 5.6.4
ENV file_server http://10.254.0.21
RUN mkdir -p /opt && \
    cd /opt && \
    curl ${file_server}/elasticsearch-${VER}.tar.gz | \
      tar -zx

FROM openjdk:8u171
ENV VER 5.6.4
# uncompress & rename svc
RUN mkdir -p /opt
WORKDIR /opt
RUN mkdir -p /data
COPY --from=build /opt/elasticsearch-${VER} /opt/elasticsearch-${VER}/
# rename svc 
RUN ln -s elasticsearch-${VER} elasticsearch && \
    echo elasticsearch ${VER} installed in /opt
WORKDIR /opt/elasticsearch
COPY elasticsearch.yml ./config/
WORKDIR /opt
RUN groupadd elsearch
RUN useradd elsearch -g elsearch -p elasticsearch
RUN chown -R elsearch:elsearch elasticsearch
RUN chown -R elsearch:elsearch elasticsearch-${VER}
RUN chown -R elsearch:elsearch /data 
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* /usr/share/man /usr/share/doc
USER elsearch
CMD ["/opt/elasticsearch/bin/elasticsearch"]
