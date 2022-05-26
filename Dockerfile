FROM openjdk:8u282-oracle AS builder
WORKDIR /opt/app
COPY ../gradle gradle
COPY ../build.gradle build.gradle
COPY ../gradlew gradlew
COPY ../settings.gradle settings.gradle
COPY ../src src
RUN ./gradlew check build

FROM openjdk:8u282-jre
WORKDIR /opt/app
COPY --from=builder /opt/app/build/libs/developer-joyofenergy-java.jar application.jar
EXPOSE 8080
HEALTHCHECK --interval=5s --timeout=1s --start-period=5s \
  CMD curl --fail http://localhost:8080/readings/read/smart-meter-0 || exit 1
ENTRYPOINT ["java", "-jar", "application.jar"]
