
FROM registry.access.redhat.com/ubi8/openjdk-11:1.3-18 AS builder
USER root
COPY . /tmp/src
RUN chown -R 185:0 /tmp/src
USER 185
RUN /usr/local/s2i/assemble


FROM registry.access.redhat.com/ubi8/openjdk-11:1.3-18
WORKDIR /deployments/
COPY --from=builder /tmp/src/target/*.jar /deployments/application
CMD ["java", "-jar", "./application", "-Dapp.http.host=0.0.0.0"]

