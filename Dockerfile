FROM openjdk:8-jre-alpine
ARG version
ENV artifact devops-petclinic-2.1.${version}.jar
WORKDIR /app
COPY  target/*.jar /app/
EXPOSE 8094
CMD ["java", "-jar", "devops-petclinic-2.1.${version}.jar"]
