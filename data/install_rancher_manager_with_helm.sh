#!/bin/bash

install_rancher() {
  clear
  echo -e "Installing Rancher Manager using Helm... \n Fetching all available versions from upstream \n \n"
  get_rancher_version
  echo "Installing Rancher $RANCHER_VERSION"
  sleep 3

  # Rancher Server Installation

  # Adding Helm-3
  curl -#L https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

  # Add needed helm charts
  helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
  helm repo add jetstack https://charts.jetstack.io

  # Add the cert-manager CRD
  kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.6.1/cert-manager.crds.yaml

  # Helm install jetstack
  helm upgrade -i cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace

  # Installing Rancher Server
  read -p "Enter your hostname: " hostname_rancher
  echo "Your provided hostname is $hostname_rancher"

  read -p "Password: " password_rancher

  # To install a specific version of Rancher
  # Get Rancher version first
  # helm search repo rancher-latest --versions

  helm upgrade -i rancher rancher-latest/rancher --version $RANCHER_VERSION --create-namespace --namespace cattle-system --set hostname=${hostname_rancher} --set bootstrapPassword=${password_rancher} --set replicas=1
  sleep 5

  kubectl get pods -A

  # Verify Rancher installation
  kubectl -n cattle-system rollout status deploy/rancher
}

get_rancher_version() {
  # Get list of available Rancher versions from GitHub API
  VERSIONS_URL="https://api.github.com/repos/rancher/rancher/releases"
  VERSIONS=$(curl -s $VERSIONS_URL | grep '"tag_name":' | cut -d '"' -f 4 | grep -v 'alpha\|beta' | sort -rV)

  # Display menu of available versions
  echo -e "Please select a Rancher version to install or use option 1 for the latest stable version: \n"
  select VERSION in "latest" $VERSIONS; do
    if [ -n "$VERSION" ]; then
      break
    fi
  done

  # Set RANCHER_VERSION variable
  if [ "$VERSION" = "latest" ]; then
    RANCHER_VERSION=$(curl -s $VERSIONS_URL | grep '"tag_name":' | cut -d '"' -f 4 | grep -v 'alpha\|beta' | head -n 1)
  else
    RANCHER_VERSION=$VERSION
  fi
}

# Call the install_rancher function
install_rancher
