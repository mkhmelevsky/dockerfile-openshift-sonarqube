#!/bin/bash

set -e

/usr/bin/pg_ctl start -D ${PGDATA} -s -o "-p ${PGPORT}" -w -t 300 2>&1

# Just wait a while
sleep 3

# Fail if server doesn't started
/usr/bin/pg_ctl status

# Generate random string to use as password for sonar user
SONAR_PASSWORD=$(</dev/urandom tr -dc _#[:alnum:] | head -c 32 | xargs /bin/echo)

# Replace dummy password with generated one
sed -i "s/sonar.jdbc.password=sonar/sonar.jdbc.password=${SONAR_PASSWORD}/g" "${SONAR_HOME}/conf/sonar.properties"

# Store credentials for later use
echo "${SONAR_PASSWORD}" > "${PGDATA}/sonar.credentials"

# Create database and grant permission to user sonar
/usr/bin/psql -d postgres -c "CREATE USER sonar WITH ENCRYPTED PASSWORD '${SONAR_PASSWORD}'"
/usr/bin/psql -d postgres -c "CREATE DATABASE sonarqube"
/usr/bin/psql -d postgres -c "GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonar"
/usr/bin/psql -d postgres -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO sonar"
/usr/bin/psql -d postgres -c "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO sonar"

/usr/bin/pg_ctl stop
