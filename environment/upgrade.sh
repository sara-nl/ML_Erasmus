#!/bin/bash

# release name is 'info-vis' and namespace is 'ns-info-vis'
helm upgrade --install dba sda-charts/sda-jupyterhub \
--version 0.1.4 \
--values values.yaml \
--tiller-namespace $NAMESPACE \
--namespace $NAMESPACE \
--tls \
--debug
