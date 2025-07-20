# AWS EC2 Setup

## Quick Start

```bash
# Show usage help (default)
curl -fsSL https://raw.githubusercontent.com/doas-ice/devops-next-japan/main/.aws/scripts/setup-ec2.sh | bash

# Start SonarQube only
curl -fsSL https://raw.githubusercontent.com/doas-ice/devops-next-japan/main/.aws/scripts/setup-ec2.sh | bash -s sonar

# Start monitoring only
curl -fsSL https://raw.githubusercontent.com/doas-ice/devops-next-japan/main/.aws/scripts/setup-ec2.sh | bash -s monitoring
```

## What it does:
1. Updates Ubuntu
2. Checks and installs Docker & Docker Compose (if needed)
3. Clones repo to `~/devops-next-japan`
4. Starts selected service (requires explicit argument)


## Services:
- SonarQube: http://your-ip:9000 (admin/admin)
- Prometheus: http://your-ip:9090
- Grafana: http://your-ip:3000 (admin/admin) 
