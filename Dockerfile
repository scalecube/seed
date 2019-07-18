FROM openjdk:8

LABEL maintainer="info@scalecube.io"

ARG EXECUTABLE_JAR

WORKDIR /opt/scalecube

ENV DEFAULT_JAVA_OPTS="-server \
-XX:+DisableExplicitGC \
-Dsun.rmi.dgc.client.gcInterval=3600000 \
-Dsun.rmi.dgc.server.gcInterval=3600000"

ENV DEFAULT_JMX_OPTS="-Djava.rmi.server.hostname=0.0.0.0 \
-Dcom.sun.management.jmxremote.port=5678 \
-Dcom.sun.management.jmxremote.rmi.port=5678 \
-Dcom.sun.management.jmxremote.authenticate=false \
-Dcom.sun.management.jmxremote.ssl=false"

ENV DEFAULT_OOM_OPTS="-XX:+HeapDumpOnOutOfMemoryError \
-XX:HeapDumpPath=dumps/oom_pid<pid>_`date`.hprof \
-XX:+UseGCOverheadLimit"

COPY target/lib lib
COPY target/${EXECUTABLE_JAR}.jar app.jar

# jmx server port
EXPOSE 5678

# Cluster control port and communication port.
EXPOSE 4801 4802

ENTRYPOINT exec java $DEFAULT_JAVA_OPTS $JAVA_OPTS $DEFAULT_JMX_OPTS $DEFAULT_OOM_OPTS -Dlog4j.configurationFile=log4j2.xml -jar app.jar $PROGRAM_ARGS

