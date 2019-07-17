#!/bin/bash

set -e

export SONAR_PASSWORD=$(cat ${PGDATA}/sonar.credentials)

/usr/bin/pg_ctl start -D ${PGDATA} -s -o "-p ${PGPORT}" -w -t 300 2>&1
sleep 3
/usr/bin/pg_ctl status

/usr/bin/psql -d postgres -c "CREATE USER sonar WITH ENCRYPTED PASSWORD '${SONAR_PASSWORD}'"
/usr/bin/psql -d postgres -c "CREATE DATABASE sonarqube"
/usr/bin/psql -d postgres -c "GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonar"
/usr/bin/psql -d postgres -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO sonar"
/usr/bin/psql -d postgres -c "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO sonar"

/usr/bin/pg_ctl stop
