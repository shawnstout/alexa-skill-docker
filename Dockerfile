FROM python:3.9-slim-buster

# Install dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    libssl-dev \
    libffi-dev \
    libcrypto++-dev \
    supervisor \
    unzip \
    curl && \
    curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | apt-key add - && \
    echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | tee /etc/apt/sources.list.d/ngrok.list && \
    apt-get update && apt-get install -y ngrok && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Copy ngrok configuration file
COPY ngrok.yml /root/.ngrok2/ngrok.yml

# Copy supervisord configuration
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy environment variable file
COPY .env .env

# Export environment variables
ENV $(cat .env | xargs)

# Configure ngrok with the auth token
RUN ngrok authtoken $NGROK_AUTH_TOKEN

EXPOSE 8080

CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
