#!/bin/bash
VER=5.6.4
groupadd elsearch
useradd elsearch -g elsearch -p elasticsearch
chown -R elsearch:elsearch /opt/elasticsearch
chown -R elsearch:elsearch /opt/elasticsearch-${VER}
