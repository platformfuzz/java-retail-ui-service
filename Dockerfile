# Build Stage
FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /build

# Copy only the files needed for Maven build
COPY pom.xml .
COPY .mvn .mvn
COPY mvnw .

# Download dependencies first (better layer caching)
RUN mvn dependency:go-offline -B -q

# Copy source code
COPY src src

# Build the application
RUN mvn -DskipTests package -q

# Runtime Stage
FROM eclipse-temurin:21-jre

WORKDIR /app

# Copy the built JAR from build stage
COPY --from=build /build/target/ui-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080

# Simple health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD java -cp app.jar org.springframework.boot.loader.JarLauncher --help > /dev/null 2>&1 || exit 1

# Run the application
CMD ["java", "-jar", "app.jar"]
