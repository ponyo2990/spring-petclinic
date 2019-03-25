FROM openjdk:8-jre-alpine
WORKDIR /app
COPY  target/*.jar /app/
EXPOSE 8094
CMD ["java", "-jar", "/app/devops-petclinic-2.1.*.jar"]
