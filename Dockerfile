# Set JAVA Version
# OPENJDK 17 EOL: 30 Sep 2026
ARG JAVA_VERSION=17

# MusicBot Build Step
FROM maven:3-openjdk-$JAVA_VERSION as builder

WORKDIR /tmp/workdir
COPY pom.xml ./
RUN mvn dependency:go-offline
COPY src/ ./src/
RUN mvn package


# MusicBot Runtime
FROM eclipse-temurin:$JAVA_VERSION-jre as runtime

WORKDIR /opt/MusicBot
COPY default_config.txt ./config.txt
COPY --from=builder /tmp/workdir/target/JMusicBot-*-All.jar /opt/MusicBot/JMusicBot.jar

CMD ["java", "-Dnogui=true", "-jar", "/opt/MusicBot/JMusicBot.jar"]
