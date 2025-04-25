
if [ "$EUID" -ne 0 ]; then 
  echo "Pls, try run with sudo"
  exit
fi

echo "Install"

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


REPO_URL="https://github.com/biparasite/VIRT-04-HW.git"
TARGET_DIR="/opt/shvirtd-example-python"

git clone "$REPO_URL" "$TARGET_DIR"

cd "$TARGET_DIR" || exit

docker compose up -d
