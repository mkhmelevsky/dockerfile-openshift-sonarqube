FROM openjdk:12-oracle

ENV \
    SONAR_VERSION=7.8 \
    SONARQUBE_HOME=/opt/sonarqube-$SONAR_VERSION

RUN set -x \
    && groupadd -r sonarqube \
    && useradd -r -g sonarqube sonarqube

ENTRYPOINT ["/bin/bash"]
