FROM openjdk:12-oracle

LABEL \
    name="SonarQube 7.8 on Oracle Linux 7 with Java JDK 1.12" \
    vendor="Max Khmelevsky <max.khmelevsky@yandex.ru>" \
    license="GPLv2" \
    build-date="20190711"

ARG \
    SONAR_VERSION=7.8

ENV \
    SONARQUBE_HOME=/opt/sonarqube-$SONAR_VERSION

RUN set -x \
    && groupadd -r sonarqube \
    && useradd -r -g sonarqube sonarqube \
    && mkdir -p /opt \
    && javac -version \
    && java -version

ENTRYPOINT ["/bin/bash"]
