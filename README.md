# SonarQube as OpenShift container

### Summary

Образ SonarQube для запуска в контейнере OpenShift с необходимыми плагинами

### Versions

    - RedHat OpenShift 3.11
    - SonarQube 7.8

### Project structure

### Dependencies

В основе образа лежит OpenJDK версии 12 [https://hub.docker.com/_/openjdk]

Начиная с версии 12, OpenJDK основывается на официальном образе Oracle Linux 7

### Variables

    - SONARQUBE_WEB_HOST    - адрес интерфейса для Nginx. По умолчанию: 0.0.0.0
    - SONARQUBE_WEB_PORT    - порт SonarQube. По-умолчанию: 9000
    - SONARQUBE_WEB_CONTEXT - контекст для Nginx. По-умолчанию: "/"
    - SONARQUBE_LOG_LEVEL   - цровень детализаци log-файлов. По-умолчанию: "INFO"

### License

Licensed under the MIT License. See the LICENSE file for details.

### Author Information

Max Khmelevsky max dot khmelevsky at yandex dot ru
