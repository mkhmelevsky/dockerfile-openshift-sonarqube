FROM openjdk:12-oracle

ARG SONAR_VERSION=7.8
ARG SONAR_HOME=/opt/sonarqube-$SONAR_VERSION

ENV SONARQUBE_VERSION="${SONAR_VERSION}" \
    SONARQUBE_HOME="${SONAR_HOME}" \
    SONARQUBE_WEB_JVM_OPTS="-Xmx512m -Xms128m"

LABEL \
    name="SonarQube Developer Edition ${SONAR_VERSION} on Oracle Linux 7 with Java JDK 1.12" \
    vendor="Max Khmelevsky <max.khmelevsky@yandex.ru>" \
    license="MIT" \
    image-version="1.6" \
    build-date="24.09.2019"

# Download and install common packages
RUN set -x \
    && groupadd -r sonarqube --gid=999 \
    && useradd -r -g sonarqube --uid=999 sonarqube \
    && mkdir -p "${SONARQUBE_HOME}" \
    && javac -version \
    && java -version \
    && yum -y update \
    && yum -y install iproute unzip \
    && yum clean all

# Download and unzip SonarQube and plugins
# This plugins set is mandatory for the all E-Commerce projects

# pub   2048R/D26468DE 2015-05-25
#       Key fingerprint = F118 2E81 C792 9289 21DB  CAB4 CFCA 4A29 D264 68DE
# uid                  sonarsource_deployer (Sonarsource Deployer) <infra@sonarsource.com>
# sub   2048R/06855C1D 2015-05-25
RUN set -x \
    && export GNUPGHOME="$(mktemp -d)" \
    && (gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys F1182E81C792928921DBCAB4CFCA4A29D26468DE \
	    || gpg --batch --keyserver ipv4.pool.sks-keyservers.net --recv-keys F1182E81C792928921DBCAB4CFCA4A29D26468DE) \
    && cd /opt \
    && curl -o sonarqube.zip -fSL "https://binaries.sonarsource.com/CommercialDistribution/sonarqube-developer/sonarqube-developer-${SONAR_VERSION}.zip" \
    && curl -o sonarqube.zip.asc -fSL "https://binaries.sonarsource.com/CommercialDistribution/sonarqube-developer/sonarqube-developer-${SONAR_VERSION}.zip.asc" \
    && gpg --batch --verify sonarqube.zip.asc sonarqube.zip \
    && unzip sonarqube.zip \
    && ln -s sonarqube-${SONAR_VERSION} sonarqube \
    && cd sonarqube-${SONAR_VERSION}/extensions/plugins \
    && curl -o checkstyle-sonar-plugin-4.21.jar -fSL "https://github.com/checkstyle/sonar-checkstyle/releases/download/4.21/checkstyle-sonar-plugin-4.21.jar" \
    && curl -o sonar-pmd-plugin-3.2.1.jar -fSL "https://github.com/SonarQubeCommunity/sonar-pmd/releases/download/3.2.1/sonar-pmd-plugin-3.2.1.jar" \
    && curl -o sonar-findbugs-plugin-3.11.0.jar -fSL "https://github.com/spotbugs/sonar-findbugs/releases/download/3.11.0/sonar-findbugs-plugin-3.11.0.jar" \
    && curl -o sonar-jdepend-plugin-1.1.1.jar -fSL "https://github.com/willemsrb/sonar-jdepend-plugin/releases/download/sonar-jdepend-plugin-1.1.1/sonar-jdepend-plugin-1.1.1.jar" \
    && curl -o sonar-jproperties-plugin-2.6.jar -fSL "https://github.com/racodond/sonar-jproperties-plugin/releases/download/2.6/sonar-jproperties-plugin-2.6.jar" \
    && curl -o sonar-dependency-check-plugin-1.2.4.jar -fSL "https://github.com/stevespringett/dependency-check-sonar-plugin/releases/download/1.2.4/sonar-dependency-check-plugin-1.2.4.jar" \
    && curl -o sonar-issueresolver-plugin-1.0.2.jar -fSL "https://github.com/willemsrb/sonar-issueresolver-plugin/releases/download/sonar-issueresolver-plugin-1.0.2/sonar-issueresolver-plugin-1.0.2.jar" \
    && curl -o sonar-json-plugin-2.3.jar -fSL "https://github.com/racodond/sonar-json-plugin/releases/download/2.3/sonar-json-plugin-2.3.jar" \
    && curl -o sonar-yaml-plugin-1.4.2.jar -fSL "https://github.com/sbaudoin/sonar-yaml/releases/download/v1.4.2/sonar-yaml-plugin-1.4.2.jar" \
    && curl -o sonar-ansible-extras-plugin-2.2.0.jar -fSL "https://github.com/sbaudoin/sonar-ansible/releases/download/v2.2.0/sonar-ansible-extras-plugin-2.2.0.jar" \
    && curl -o sonar-shellcheck-plugin-2.1.0.jar -fSL "https://github.com/sbaudoin/sonar-shellcheck/releases/download/v2.1.0/sonar-shellcheck-plugin-2.1.0.jar" \
    && curl -o qualinsight-sonarqube-smell-plugin-4.0.0.jar -fSL "https://github.com/QualInsight/qualinsight-plugins-sonarqube-smell/releases/download/qualinsight-plugins-sonarqube-smell-4.0.0/qualinsight-sonarqube-smell-plugin-4.0.0.jar" \
    && rm -rf "$GNUPGHOME" ${SONAR_HOME}/bin/* \
    && rm /opt/sonarqube.zip*

COPY bitegarden-sonarqube-security-1.2.3-sq-6.7.jar "${SONAR_HOME}/extensions/plugins/"
COPY sonar.properties "${SONAR_HOME}/conf/"
COPY run.sh "${SONAR_HOME}/bin/"

RUN set -x \
    && chown -R sonarqube:sonarqube "${SONAR_HOME}" \
    && chmod +x ${SONAR_HOME}/bin/run.sh

EXPOSE 9000

VOLUME ${SONAR_HOME}/data

WORKDIR ${SONAR_HOME}

USER sonarqube

ENTRYPOINT ["./bin/run.sh"]
