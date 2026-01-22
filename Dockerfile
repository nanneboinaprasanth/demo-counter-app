    # -------- Build stage --------
FROM maven:3.9.6-eclipse-temurin-11 AS build
WORKDIR /app

COPY . .
RUN mvn clean install -DskipTests

# -------- Runtime stage --------
FROM eclipse-temurin:11-jre-jammy
WORKDIR /app

COPY --from=build /app/target/Uber.jar /app/Uber.jar

EXPOSE 8082
CMD ["java","-jar","/app/Uber.jar"]
