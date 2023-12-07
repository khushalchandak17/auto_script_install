#!/bin/bash
install_k3s() {
  clear
  echo -e "Installing k3s... \n Fetching all the avaialble version from upstream \n \n"
  get_k3s_version
  echo "$K3S_VERSION"
  sleep 2

  curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=$K3S_VERSION sh -

  # Verify k3s installation
  sudo k3s kubectl get nodes

  mkdir ~/.kube/
  cp /etc/rancher/k3s/k3s.yaml  ~/.kube/config
  #export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

  for i in $(kubectl get deploy -n kube-system --no-headers | awk '{print $1}'); do  kubectl -n kube-system rollout status deploy $i; done

}

function get_k3s_version {
  # Get list of available k3s versions from GitHub API
  VERSIONS_URL="https://api.github.com/repositories/135516270/releases"
  VERSIONS=$(curl -s $VERSIONS_URL | grep '"tag_name":' | cut -d '"' -f 4 | sort -rV)

  # Display menu of available versions
  echo -e "Please select a k3s version to install or use option 1 for the latest stable version: \n"
  select VERSION in "latest" $VERSIONS ; do
    if [ -n "$VERSION" ]; then
      break
    fi
  done

  # Set K3S_VERSION variable
  if [ "$VERSION" = "latest" ]; then
    K3S_VERSION=$(curl -s $VERSIONS_URL | grep '"name":' | cut -d '"' -f 4 | head -n 1)
  else
    K3S_VERSION=$VERSION
  fi
}

install_k3s
