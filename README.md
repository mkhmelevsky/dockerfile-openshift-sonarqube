# SonarQube as OpenShift container

### Summary

Образ SonarQube Developer Edition для запуска в контейнере OpenShift с необходимыми плагинами

### Versions

    - RedHat OpenShift 3.11
    - SonarQube Developer Edition 7.8

### Plug-ins

Образ SonarQube включает следующие плагины:

    - checkstyle-sonar-plugin-4.21.jar
    - sonar-pmd-plugin-3.2.1.jar
    - sonar-findbugs-plugin-3.11.0.jar
    - sonar-jdepend-plugin-1.1.1.jar
    - sonar-jproperties-plugin-2.6.jar
    - sonar-dependency-check-plugin-1.2.4.jar
    - sonar-issueresolver-plugin-1.0.2.jar
    - sonar-json-plugin-2.3.jar
    - sonar-yaml-plugin-1.4.2.jar
    - sonar-ansible-extras-plugin-2.2.0.jar
    - sonar-shellcheck-plugin-2.1.0.jar
    - qualinsight-sonarqube-smell-plugin-4.0.0.jar


### Dependencies

В основе образа лежит OpenJDK версии 12 [https://hub.docker.com/_/openjdk], собраный на официальном образе Oracle Linux 7

### Variables

Следующие параметры могут быть заданы через переменные окружения

    - sonar.web.host            Адрес интерфейса для Nginx. По умолчанию: 0.0.0.0
    - sonar.web.port            Порт SonarQube. По-умолчанию: 9000
    - sonar.web.context         Контекст вызова. По-умолчанию: "/"

    - sonar.jdbc.username       Имя пользователя для подключения к БД. По-умолчанию: "sonar"
    - sonar.jdbc.password       Пароль полльзователя для подключения к БД. По-умолчанию: "sonar"
    - sonar.jdbc.url            Строка подключения к БД. По-умолчанию: "jdbc:postgresql://localhost:5432/sonarqube"

    - sonar.log.level           Уровень детализаци log-файлов. По-умолчанию: "INFO"
    - sonar.web.javaOpts        Параметры Java VM для Web-компоненты. По-умолчанию: "-Xmx512m -Xms128m"
    - sonar.search.javaOpts     Параметры Java VM для Search-компоненты. По-умолчанию: "-Xmx1g -Xms1g"
    - sonar.ce.javaOpts         Параметры Java VM для CE-компоненты. По-умолчанию: "-Xmx512m -Xms128m"

### License

Licensed under the MIT License. See the LICENSE file for details.

### Author Information

Max Khmelevsky max dot khmelevsky at yandex dot ru
