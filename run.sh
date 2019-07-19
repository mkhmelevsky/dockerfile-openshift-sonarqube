#!/usr/bin/env bash

set -e

if [ "${1:0:1}" != '-' ]; then
  exec "$@"
fi

# Parse Docker env vars to customize SonarQube
# e.g. Setting the env var sonar.jdbc.username=foo
# will cause SonarQube to be invoked with -Dsonar.jdbc.username=foo

declare -a sq_opts

while IFS='=' read -r envvar_key envvar_value
do
    if [[ "$envvar_key" =~ sonar.* ]] || [[ "$envvar_key" =~ ldap.* ]]; then
        sq_opts+=("-D${envvar_key}=${envvar_value}")        
    fi
done < <(env)

# Start SonarQube server
echo "Starting SonarQube-${SONARQUBE_VERSION}..."


echo "$ exec java -jar ${SONARQUBE_HOME}/lib/sonar-application-${SONARQUBE_VERSION}.jar \
  -Dsonar.log.console=true \
  -Dsonar.web.javaAdditionalOpts=${SONARQUBE_WEB_JVM_OPTS} -Djava.security.egd=file:/dev/./urandom \
  ${sq_opts[@]} $@"

exec java -jar ${SONARQUBE_HOME}/lib/sonar-application-${SONARQUBE_VERSION}.jar \
  -Dsonar.log.console=true \
  -Dsonar.web.javaAdditionalOpts="${SONARQUBE_WEB_JVM_OPTS}" -Djava.security.egd="file:/dev/./urandom" \
  "${sq_opts[@]}" \
  "$@"
