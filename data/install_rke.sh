clear
  echo -e "Installing RKE... \n Fetching all the avaialble version from upstream \n \n"
  # Add your installation logic for RKE here
  get_rke_version
  echo "$RKE_VERSION"
  sleep 3
  # Download and install RKE binary
  architecture=$(uname -m)

if [ "$architecture" == "x86_64" ]; then
    echo "AMD architecture detected. Continuing with AMD-specific actions..."
      RKE_arc=rke_linux-amd64
else
    echo "ARM architecture detected. Continuing with ARM-specific actions..."
      RKE_arc=rke_linux-arm64
fi

  RKE_DOWNLOAD_URL="https://github.com/rancher/rke/releases/download/$RKE_VERSION/$RKE_arc"
  curl -LO $RKE_DOWNLOAD_URL
  sudo install $RKE_arc /usr/local/bin/rke

  # Verify RKE installation
  rke --version
  sleep 3
  ssh_config_rke

  sleep 1

  rke config
  rke up
  mkdir ~/.kube
  cp kube_config_cluster.yml ~/.kube/config

  sleep 5

kubectl cluster-info
kubectl get nodes
kubectl get cs
