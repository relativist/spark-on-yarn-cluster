echo "Manual run commands here."
exit 1

# Деплой приложения в спарк контейнер.
# Не для этого стенда, когда спарк запускается сам по-себе. Один Мастер и отдельно воркеры.
spark-submit --deploy-mode cluster \
--master spark://spark:7077 \
--total-executor-cores 1 \
--class ru.element.lab.SendBoxApplication \
--driver-memory 1G \
--executor-memory 1G \
--conf spark.kafka.bootstrap.servers=192.168.2.5:9092 \
--properties-file=/opt/bitnami/spark/apps/spark-1.properties \
/opt/bitnami/spark/apps/sandbox-kafka-streaming.jar

# Простой запуск на клиенте!
spark-submit --deploy-mode client \
--total-executor-cores 1 \
--class ru.element.lab.SendBoxApplication \
--executor-memory 1G \
--properties-file=/opt/bitnami/spark/apps/spark-1.properties \
/opt/bitnami/spark/apps/sandbox-kafka-streaming.jar

# Простой запуск на кластере!
spark-submit --deploy-mode cluster \
--master yarn \
--total-executor-cores 1 \
--class org.apache.spark.examples.SparkPi \
--executor-memory 1G \
--properties-file=/opt/spark/user_files/spark-1.properties \
/opt/spark/user_files/spark-examples_2.12-3.3.0.jar

# Деплой на кластер с локальной кафкой и пр параметрами.
spark-submit --deploy-mode cluster \
--name sandbox-kafka-streaming \
--master yarn \
--total-executor-cores 1 \
--class ru.element.lab.SendBoxApplication \
--driver-memory 1G \
--executor-memory 1G \
--conf spark.kafka.bootstrap.servers=192.168.2.5:9092 \
--conf spark.ssl.security.protocol=PLAINTEXT \
--files '/opt/spark/user_files/cmp-dev2-kafka-all.truststore.jks,/opt/spark/user_files/cmp-dev2-kafka-all.keystore.jks,/opt/spark/user_files/log4j.xml' \
--properties-file=/opt/spark/user_files/spark-1.properties \
--conf spark.ssl.truststore.location=cmp-dev2-kafka-all.truststore.jks \
--conf spark.ssl.truststore.password=dm4zOKvUHZT7 \
--conf spark.ssl.keystore.location=cmp-dev2-kafka-all.keystore.jks \
--conf spark.ssl.keystore.password=dm4zOKvUHZT7 \
--conf spark.yarn.submit.waitAppCompletion=false \
--conf spark.hadoop.url=hadoopname-sdp-01.gisoms-platform.dev2.pd15.foms.mtp:8020 \
--class ru.element.lab.SendBoxApplication \
--executor-cores 1 \
--conf spark.serializer=org.apache.spark.serializer.KryoSerializer \
--driver-class-path /opt/spark/user_files/jars \
--jars '/opt/spark/user_files/jars/postgresql-42.4.2.jar,/opt/spark/user_files/jars/spark-sql_2.12-3.0.1.jar,/opt/spark/user_files/jars/spark-sql-kafka-0-10_2.12-3.0.1.jar,/opt/spark/user_files/jars/spark-streaming_2.12-3.0.1.jar,/opt/spark/user_files/jars/spark-streaming-kafka-0-10_2.12-3.0.1.jar,/opt/spark/user_files/jars/spark-token-provider-kafka-0-10_2.12-3.0.1.jar,/opt/spark/user_files/jars/kafka-clients-3.1.1.jar,/opt/spark/user_files/jars/oms-api-pd15-0.7.1-SNAPSHOT.jar,/opt/spark/user_files/jars/semd-api-0.1.0-SNAPSHOT.jar,/opt/spark/user_files/jars/jackson-datatype-jsr310-2.15.0.jar,/opt/spark/user_files/jars/gson-2.9.1.jar,/opt/spark/user_files/jars/greenplum-connector-apache-spark-scala_2.12-2.1.4.jar' \
user_files/sandbox-kafka-streaming.jar

# PD15 Деплой (но докер сеть не имеет доступа до кафки)
spark-submit \
--name sandbox-kafka-streaming \
--files '/opt/spark/user_files/cmp-dev2-kafka-all.truststore.jks,/opt/spark/user_files/cmp-dev2-kafka-all.keystore.jks,/opt/spark/user_files/log4j.xml' \
--properties-file=/opt/spark/user_files/spark-1.properties \
--conf spark.ssl.truststore.location=cmp-dev2-kafka-all.truststore.jks \
--conf spark.ssl.truststore.password=dm4zOKvUHZT7 \
--conf spark.ssl.keystore.location=cmp-dev2-kafka-all.keystore.jks \
--conf spark.ssl.keystore.password=dm4zOKvUHZT7 \
--conf spark.ssl.security.protocol=SSL \
--conf spark.kafka.bootstrap.servers=kafka-cmp-01.gisoms-customer.dev2.pd15.foms.mtp:9093 \
--conf spark.yarn.submit.waitAppCompletion=false \
--conf spark.hadoop.url=hadoopname-sdp-01.gisoms-platform.dev2.pd15.foms.mtp:8020 \
--class ru.element.lab.SendBoxApplication \
--deploy-mode cluster \
--driver-memory 1g \
--executor-memory 1g \
--executor-cores 1 \
--master yarn \
--conf spark.serializer=org.apache.spark.serializer.KryoSerializer \
--conf spark.dynamicAllocation.maxExecutors=2 \
--conf spark.dynamicAllocation.minExecutors=2 \
--driver-class-path /opt/spark/user_files/jars \
--jars '/opt/spark/user_files/jars/postgresql-42.4.2.jar,/opt/spark/user_files/jars/spark-sql_2.12-3.0.1.jar,/opt/spark/user_files/jars/spark-sql-kafka-0-10_2.12-3.0.1.jar,/opt/spark/user_files/jars/spark-streaming_2.12-3.0.1.jar,/opt/spark/user_files/jars/spark-streaming-kafka-0-10_2.12-3.0.1.jar,/opt/spark/user_files/jars/spark-token-provider-kafka-0-10_2.12-3.0.1.jar,/opt/spark/user_files/jars/kafka-clients-3.1.1.jar,/opt/spark/user_files/jars/oms-api-pd15-0.7.1-SNAPSHOT.jar,/opt/spark/user_files/jars/semd-api-0.1.0-SNAPSHOT.jar,/opt/spark/user_files/jars/jackson-datatype-jsr310-2.15.0.jar,/opt/spark/user_files/jars/gson-2.9.1.jar,/opt/spark/user_files/jars/greenplum-connector-apache-spark-scala_2.12-2.1.4.jar' \
user_files/sandbox-kafka-streaming.jar
