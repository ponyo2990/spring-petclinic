FROM openjdk:8-jre-alpine
ARG version
WORKDIR /app
COPY  target/*.jar /app
EXPOSE 8094
ENTRYPOINT ["sh", "-c"]
CMD ["java", "-jar", "devops-petclinic-2.1.${version}.jar"]
