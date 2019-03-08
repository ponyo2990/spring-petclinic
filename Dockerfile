FROM openjdk:8-jre-alpine
WORKDIR /app
COPY  target/*.jar /app
EXPOSE 8094
CMD ["java", "-jar", "devops-petclinic-2.1.0.BUILD-SNAPSHOT.jar"]
