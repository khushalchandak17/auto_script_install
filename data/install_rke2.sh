#!/bin/bash
install_rke2() {
clear


echo -e "Installing RKE2 Server ... \n Fetching all the avaialble version from upstream \n \n"
# Add your installation logic for RKE2 Server using apt here
get_rke2_version
echo "$RKE2_VERSION"
sleep 2

## Using script not apt
# On rancher1
curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE=server INSTALL_RKE2_CHANNEL=$RKE2_VERSION sh -

# start and enable for restarts -
echo -e "\n initializing  RKE2 Server"
systemctl enable --now rke2-server.service

systemctl status rke2-server --no-pager

cp $(find /var/lib/rancher/rke2/data/ -name kubectl) /usr/local/bin/kubectl
chmod +x /usr/local/bin/kubectl

mkdir ~/.kube/
cp /etc/rancher/rke2/rke2.yaml  ~/.kube/config
#export KUBECONFIG=/etc/rancher/rke2/rke2.yaml

kubectl version --short

kubectl get node -o wide
sleep 8

for i in $(kubectl get deploy -n kube-system --no-headers | awk '{print $1}'); do  kubectl -n kube-system rollout status deploy $i; done

sleep 2

}

# Function to display menu for all avaialble RKE2 version and get user's choice
function get_rke2_version {
  # Get list of available RKE2 versions from GitHub API
architecture=$(uname -m)
VERSIONS_URL="https://api.github.com/repos/rancher/rke2/releases"

if [ "$architecture" == "x86_64" ] || [ "$architecture" == "amd64" ]; then
  VERSIONS=$(curl -s $VERSIONS_URL | grep '"tag_name":' | cut -d '"' -f 4 | sort -rV)
elif [ "$architecture" == "arm" ] || [ "$architecture" == "aarch64" ]; then
  VERSIONS=$(curl -s $VERSIONS_URL | grep '"tag_name":' | cut -d '"' -f 4 | grep -E '^v(1\.27\.|1\.28\.)' | sort -rV)
else
  echo "Unsupported architecture '$architecture' detected. Quitting..."
  exit 1
fi


  # Add "Latest" option to the list
  VERSIONS="Latest $VERSIONS"

  # Display menu of available versions
  echo -e "Please select an RKE2 version to install or use option 1 for the latest stable version: \n"
  select VERSION in $VERSIONS; do
    if [ -n "$VERSION" ]; then
      break
    fi
  done

  # Check if "Latest" option was selected
  if [ "$VERSION" = "Latest" ]; then
    # Fetch the latest version from the GitHub API
    LATEST_VERSION=$(curl -s $VERSIONS_URL | grep '"tag_name":' | cut -d '"' -f 4 | head -n 1)
    RKE2_VERSION=$LATEST_VERSION
  else
    # Set RKE2_VERSION variable to the selected version
    RKE2_VERSION=$VERSION
  fi
}
install_rke2
