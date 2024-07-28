# Stop and remove any existing container
docker stop alexa-skill-docker || true
docker rm alexa-skill-docker || true

# Build the Docker image
docker build -t alexa-skill-docker .

# Run the Docker container
docker run -d -p 8080:8080 --env-file .env --name alexa-skill-docker alexa-skill-docker

# Display logs from the running container
docker logs -f alexa-skill-docker
