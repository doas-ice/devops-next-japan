#!/bin/bash

set -e

REPO_URL="https://github.com/doas-ice/devops-next-japan.git"
REPO_DIR="$HOME/devops-next-japan"

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install Docker
install_docker() {
    # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update

    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

# Function to setup repository
setup_repo() {
    if [ ! -d "$REPO_DIR" ]; then
        echo "Cloning repository..."
        git clone "$REPO_URL" "$REPO_DIR"
    else
        echo "Repository exists, pulling latest changes..."
        cd "$REPO_DIR"
        git pull origin main
    fi
}

# Function to start SonarQube
start_sonarqube() {
    echo "Starting SonarQube..."
    cd "$REPO_DIR/.aws/sonarqube"
    docker compose up -d
    echo "SonarQube: http://$(curl -s ifconfig.me):9000"
}

# Function to start monitoring
start_monitoring() {
    echo "Starting monitoring..."
    cd "$REPO_DIR/.aws/monitoring"
    docker compose up -d
    echo "Prometheus: http://$(curl -s ifconfig.me):9090"
    echo "Grafana: http://$(curl -s ifconfig.me):3000"
}

# Main script logic
echo "AWS EC2 Setup Script"

# Update system
echo "Updating Ubuntu..."
sudo apt update && sudo apt upgrade -y

# Check and install Docker
if ! command_exists docker; then
    install_docker
else
    echo "Docker already installed"
fi

# Add user to docker group for non-root access
sudo usermod -aG docker $USER
echo "Docker and Docker Compose installation complete!"
echo "Note: You may need to log out and back in for group changes to take effect."

# Setup repository
setup_repo

# Start services based on arguments
case "${1:-}" in
    "sonar"|"sonarqube")
        start_sonarqube
        ;;
    "monitoring"|"monitor")
        start_monitoring
        ;;
    *)
        echo "Usage: $0 [sonar|monitoring]"
        echo "  sonar      - Start SonarQube only"
        echo "  monitoring - Start monitoring stack only"
        exit 1
        ;;
esac

echo "Setup complete!" 