#!/bin/bash

set -e

AWS_REGION="${aws_region}"
ECR_REPOSITORY_URL="${ecr_repository_url}"
IMAGE_TAG_PARAMETER="${image_tag_parameter}"
RDS_HOST="${rds_address}"
RDS_SECRET_ARN="${rds_secret_arn}"

apt-get update

# Docker + tools
apt-get install -y docker.io jq curl unzip

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
  -o "/tmp/awscliv2.zip"

unzip -q /tmp/awscliv2.zip -d /tmp

/tmp/aws/install

aws --version

systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu

# AWS Systems Manager Agent
systemctl enable snap.amazon-ssm-agent.amazon-ssm-agent.service
systemctl start snap.amazon-ssm-agent.amazon-ssm-agent.service


cat > /usr/local/bin/deploy-app <<'EOF'
#!/bin/bash

set -e

AWS_REGION="${aws_region}"
ECR_REPOSITORY_URL="${ecr_repository_url}"
IMAGE_TAG_PARAMETER="${image_tag_parameter}"
RDS_HOST="${rds_address}"
RDS_SECRET_ARN="${rds_secret_arn}"
DB_NAME="appdb"

# 1. Get desired application version
IMAGE_TAG=$(aws ssm get-parameter \
  --name "$IMAGE_TAG_PARAMETER" \
  --region "$AWS_REGION" \
  --query "Parameter.Value" \
  --output text)

# 2. Get database credentials
DB_SECRET=$(aws secretsmanager get-secret-value \
  --secret-id "$RDS_SECRET_ARN" \
  --region "$AWS_REGION" \
  --query "SecretString" \
  --output text)

DB_USER=$(echo "$DB_SECRET" | jq -r '.username')
DB_PASSWORD=$(echo "$DB_SECRET" | jq -r '.password')

# 3. Authenticate to ECR
ECR_REGISTRY=$(echo "$ECR_REPOSITORY_URL" | cut -d/ -f1)

aws ecr get-login-password \
  --region "$AWS_REGION" \
  | docker login \
      --username AWS \
      --password-stdin "$ECR_REGISTRY"

# 4. Pull desired application image
docker pull "$ECR_REPOSITORY_URL:$IMAGE_TAG"

# 5. Replace current application container
docker rm -f app || true

docker run -d \
  --name app \
  --restart unless-stopped \
  -p 8000:8000 \
  -e DB_HOST="$RDS_HOST" \
  -e DB_PORT="5432" \
  -e DB_NAME="$DB_NAME" \
  -e DB_USER="$DB_USER" \
  -e DB_PASSWORD="$DB_PASSWORD" \
  "$ECR_REPOSITORY_URL:$IMAGE_TAG"
EOF

chmod +x /usr/local/bin/deploy-app

/usr/local/bin/deploy-app