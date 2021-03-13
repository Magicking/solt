FROM gradle:jdk11 as build
WORKDIR /app
COPY . .

# This changes default user to root
USER root

RUN apt-get update && apt-get -y install libncurses5 libcurl4-openssl-dev

# This changes ownership of folder
RUN chown -R gradle /app
# This downgrades the user back to the default user "gradle"
USER gradle

RUN ./gradlew assemble

FROM gradle:jre11

COPY --from=build /app/build/bin/linuxX64/releaseExecutable/solt.kexe /

RUN chown -R gradle /mnt

USER gradle

WORKDIR /mnt

ENTRYPOINT [ "/solt.kexe" ]
