# -------- Build stage --------
FROM maven:3.9.6-eclipse-temurin-11 AS build
WORKDIR /app

COPY . .
RUN mvn clean install -DskipTests

# -------- Runtime stage --------
FROM openjdk:11-jre-slim
WORKDIR /app

COPY --from=build /app/target/uber.jar /app/uber.jar

EXPOSE 8082
CMD ["java","-jar","/app/uber.jar"]

