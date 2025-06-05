#!/bin/bash

ORANGE='\033[38;5;208m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
NC='\033[0m'

center_text() {
  term_width=$(tput cols)
  text="$1"
  text_len=${#text}
  padding=$(( (term_width - text_len) / 2 ))
  printf "%*s%s\n" $padding "" "$text"
}

clear

echo -e "${ORANGE}"
echo "                                                                                                         ";
echo "                                                                                                         ";
echo "                    XXXXXXX       XXXXXXX  iiii                         999999999          888888888     ";
echo "                    X:::::X       X:::::X i::::i                      99:::::::::99      88:::::::::88   ";
echo "                    X:::::X       X:::::X  iiii                     99:::::::::::::99  88:::::::::::::88 ";
echo "                    X::::::X     X::::::X                          9::::::99999::::::98::::::88888::::::8";
echo "xxxxxxx      xxxxxxxXXX:::::X   X:::::XXXiiiiiii nnnn  nnnnnnnn    9:::::9     9:::::98:::::8     8:::::8";
echo " x:::::x    x:::::x    X:::::X X:::::X   i:::::i n:::nn::::::::nn  9:::::9     9:::::98:::::8     8:::::8";
echo "  x:::::x  x:::::x      X:::::X:::::X     i::::i n::::::::::::::nn  9:::::99999::::::9 8:::::88888:::::8 ";
echo "   x:::::xx:::::x        X:::::::::X      i::::i nn:::::::::::::::n  99::::::::::::::9  8:::::::::::::8  ";
echo "    x::::::::::x         X:::::::::X      i::::i   n:::::nnnn:::::n    99999::::::::9  8:::::88888:::::8 ";
echo "     x::::::::x         X:::::X:::::X     i::::i   n::::n    n::::n         9::::::9  8:::::8     8:::::8";
echo "     x::::::::x        X:::::X X:::::X    i::::i   n::::n    n::::n        9::::::9   8:::::8     8:::::8";
echo "    x::::::::::x    XXX:::::X   X:::::XXX i::::i   n::::n    n::::n       9::::::9    8:::::8     8:::::8";
echo "   x:::::xx:::::x   X::::::X     X::::::Xi::::::i  n::::n    n::::n      9::::::9     8::::::88888::::::8";
echo "  x:::::x  x:::::x  X:::::X       X:::::Xi::::::i  n::::n    n::::n     9::::::9       88:::::::::::::88 ";
echo " x:::::x    x:::::x X:::::X       X:::::Xi::::::i  n::::n    n::::n    9::::::9          88:::::::::88   ";
echo "xxxxxxx      xxxxxxxXXXXXXX       XXXXXXXiiiiiiii  nnnnnn    nnnnnn   99999999             888888888     ";
echo "                                                                                                         ";
echo "                                                                                                         ";
echo "                                                                                                         ";
echo "                                                                                                         ";
echo "                                                                                                         ";
echo "                                                                                                         ";
echo "                                                                                                         ";
echo "                                                                                                         ";
echo -e "${NC}"


echo -e "${YELLOW}🚀 Welcome to the xXin98 Setup Script!${NC}"
echo -e "${CYAN}🐦 Follow us on Twitter: @xXin98 ${NC}"


sleep 5

#!/bin/bash


#!/bin/bash

# Check for curl and install if not present
if ! command -v curl &> /dev/null; then
    sudo apt update
    sudo apt install curl -y
fi
sleep 1

echo "Installing Gensyn node..."

# Update and install dependencies
sudo apt-get update && sudo apt-get upgrade -y
sudo apt install curl build-essential git wget lz4 jq make gcc nano automake autoconf tmux htop nvme-cli libgbm1 pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip libleveldb-dev -y

# Check if Docker is installed and install it if not
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Installing Docker..."
    sudo apt install docker.io -y
fi

# Check if Docker Compose is installed and install it if not
if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose is not installed. Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

sudo usermod -aG docker $USER
sleep 1
sudo apt-get install python3 python3-pip
sleep 1

# Clone the repository
git clone https://github.com/gensyn-ai/rl-swarm/
cd rl-swarm

# Backup the old docker-compose.yaml
mv docker-compose.yaml docker-compose.yaml.old

# Create the new docker-compose.yaml
cat << 'EOF' > docker-compose.yaml
version: '3'

services:
  otel-collector:
    image: otel/opentelemetry-collector-contrib:0.120.0
    ports:
      - "4317:4317"  # OTLP gRPC
      - "4318:4318"  # OTLP HTTP
      - "55679:55679"  # Prometheus metrics (optional)
    environment:
      - OTEL_LOG_LEVEL=DEBUG

  swarm_node:
    image: europe-docker.pkg.dev/gensyn-public-b7d9/public/rl-swarm:v0.0.2
    command: ./run_hivemind_docker.sh
    #runtime: nvidia  # Enables GPU support; remove if no GPU is available
    environment:
      - OTEL_EXPORTER_OTLP_ENDPOINT=http://otel-collector:4317
      - PEER_MULTI_ADDRS=/ip4/38.101.215.13/tcp/30002/p2p/QmQ2gEXoPJg6iMBSUFWGzAabS2VhnzuS782Y637hGjfsRJ
      - HOST_MULTI_ADDRS=/ip4/0.0.0.0/tcp/38331
    ports:
      - "38331:38331"  # Exposes the swarm node's P2P port
    depends_on:
      - otel-collector

  fastapi:
    build:
      context: .
      dockerfile: Dockerfile.webserver
    environment:
      - OTEL_SERVICE_NAME=rlswarm-fastapi
      - OTEL_EXPORTER_OTLP_ENDPOINT=http://otel-collector:4317
      - INITIAL_PEERS=/ip4/38.101.215.13/tcp/30002/p2p/QmQ2gEXoPJg6iMBSUFWGzAabS2VhnzuS782Y637hGjfsRJ
    ports:
      - "8177:8000"  # Maps port 8177 on the host to 8000 in the container 
    depends_on:
      - otel-collector
      - swarm_node
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8000/api/healthz"]
      interval: 30s
      retries: 3
EOF

# Pull the latest images and start the containers
docker-compose pull
docker-compose up --build -d

# Final message
echo "------------------------------------------------------------"
echo "Node installed successfully."
echo "Thank you for waiting. Please proceed to the next step."
echo "------------------------------------------------------------"
sleep 2
docker-compose logs -f swarm_node