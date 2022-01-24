apt-get update
apt-get install -y git git-lfs openssh-server curl tar ca-certificates
GITLAB_RUNNER_VERSION="${GITLAB_RUNNER_VERSION:-latest}"
curl -LJO "https://gitlab-runner-downloads.s3.amazonaws.com/${GITLAB_RUNNER_VERSION}/deb/gitlab-runner_amd64.deb"
dpkg -i gitlab-runner_amd64.deb
