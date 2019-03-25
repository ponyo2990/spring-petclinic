FROM openjdk:8-jre-alpine
RUN mkdir /app
COPY  target/*.jar /app/
WORKDIR /app
EXPOSE 8080
CMD ["java", "-jar", "devops-petclinic-2.1.0.SNAPSHOT.jar"]
