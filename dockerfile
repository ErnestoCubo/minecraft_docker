# Use a base image with Java (e.g., AdoptOpenJDK)
ARG BASE_IMAGE=eclipse-temurin:17-jre-focal
FROM ${BASE_IMAGE}

# Install apt-utils
RUN apt-get update && apt-get install -y apt-utils

# Set environment variables
ENV MINECRAFT_VERSION=1.20
ENV EULA=true

# Create a directory to store the Minecraft server files
WORKDIR /minecraft

# Download the Minecraft server jar file
RUN /bin/sh -c "curl -o /minecraft/server.jar 'https://piston-data.mojang.com/v1/objects/5b868151bd02b41319f54c8d4061b8cae84e665c/server.jar'"

# Accept the Minecraft End User License Agreement (EULA)
RUN echo "eula=${EULA}" > eula.txt

# Copy the server.properties file into the image
COPY server.properties /minecraft/server.properties

# Enable RCON and set the RCON password in server.properties
RUN echo "enable-rcon=true" >> server.properties && \
    echo "rcon.password=Ponchito1" >> server.properties

# Expose the port the Minecraft server will listen on (default is 25565)
EXPOSE 25565

# Start the Minecraft server
CMD ["java", "-Xmx2G", "-Xms1G", "-jar", "/minecraft/server.jar", "nogui"]
