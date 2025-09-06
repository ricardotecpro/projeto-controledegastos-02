# Estágio 1: Build da Aplicação com Eclipse Temurin JDK
# Esta imagem é o padrão da indústria para build de aplicações Java.
FROM eclipse-temurin:21-jdk-jammy as builder
WORKDIR /app
COPY .mvn/ .mvn
COPY mvnw .
COPY pom.xml .
RUN ./mvnw dependency:go-offline
COPY src ./src
RUN ./mvnw clean package -DskipTests

# Estágio 2: Imagem Final de Execução com Eclipse Temurin JRE
# Usamos a versão JRE, que é mais leve e segura para produção.
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]