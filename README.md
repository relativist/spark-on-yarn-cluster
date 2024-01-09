# Поднятие кластера (hadoop, hdfs, spark) через docker образы.
## Версии как на гостехе: 
### spark 3.0.1
### hadoop 3.1.3

## Подготовка:
/etc/hosts:
127.0.1.1       ВАШ_ХОСТ_ИМЯ spark historyserver resourcemanager

## Особенности поднятия:
### Шаг1: 
docker-compose -f spark-client-docker-compose.yml up -d --build

### Статус сервисов:
* docker-compose -f spark-client-docker-compose.yml ps nodemanager
* docker-compose -f spark-client-docker-compose.yml ps historyserver

(!!! Падает зачастую после нескольких минут. Требует перезапуска.)
* docker-compose -f spark-client-docker-compose.yml ps resourcemanager
* docker-compose -f spark-client-docker-compose.yml up -d resourcemanager

### Шаг2:
Запуск spark + проброс портов. (Не даст войти если resourcemanager упал, нужно переподнять)
* docker-compose -f spark-client-docker-compose.yml run -p 18080:18080 spark-client bash

### Шаг3: 
Внутри контейнера
* docker: setup-history-server.sh



## Доступные ресурсы:
http://spark:8088/cluster
http://localhost:18080/
http://localhost:9870/explorer.html#/
http://spark:8188/applicationhistory/apps/FINISHED
http://resourcemanager:8088/cluster/apps
http://resourcemanager:8088/proxy/application_1703617690363_0002/streaming/
http://resourcemanager:8088/proxy/application_1703617690363_0002/executors/
http://historyserver:8188/

!!! Для просмотра логов надо изменить неизвестный хост (напр dhferim) на spark.

Дополнительные команды:

### Убить приложение внутри контейнера:
yarn application --list \
yarn application --kill

### Посмотреть айпишники всех докер контейнеров на машине.
docker ps -q | xargs -n 1 docker inspect --format '{{ .Name }} {{range .NetworkSettings.Networks}} {{.IPAddress}}{{end}}' | sed 's#^/##';


# Важно:
* При повторном деплое нужно убить приложение (это так же можно сделать в UI)
* При поднятии стенда все ранее запущенные приложения поднимаются и стоят в статусе PENDING и не могут подняться. 
Поэтому следует их убивать.
* Можно поставить свою версию java
* Монтировать свои библиотеки можно в jar архив рядом.
* Деплой приложений можно подсмотреть рядом в файле deploy.sh Команды следует выполнять ВНУТРИ контейнера.





