#!/bin/bash
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

# Get the full path to the directory containing this script
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
export SCRIPT_DIR

main() {
  while true; do
    sleep 1
    clear
    show_menu
    case $choice in
      1) execute_script "install_ubuntu_dependencies.sh" ;;
      2) execute_script "install_rancher_manager_with_helm.sh" ;;
      3) execute_script "install_rancher_manager_with_docker.sh" ;;
      4) execute_script "install_rke.sh" ;;
      5) execute_script "install_rke2.sh" ;;
      6) execute_script "install_k3s.sh" ;;
      7) execute_script "install_kubectl.sh" ;;
      8) execute_script "deploy_dns_server.sh" ;;
      9) execute_script "uninstall_all.sh" ;;
      10) execute_script "create_rke2_config.sh" ;;
      11) execute_script "deploy_private_registry.sh" ;;
      12) execute_script "install_docker.sh" ;;
      13) execute_script "install_helm.sh" ;;
      14) echo "Exiting..."; sleep 2; clear; exit 0 ;;
      *) invalid "Invalid option. Please try again." ;;
    esac
  done
}

execute_script() {
  script_name=$1
  script_path="$SCRIPT_DIR/data/$script_name"

  echo; echo
  # Check if the script is present and executable
  if [ -f "$script_path" ]; then
    if [ -x "$script_path" ]; then
      echo "Executing $script_name..."
      sleep 1
      bash "$script_path"
    else
      echo "Error: The script $script_path is not executable."
      echo "Please ensure it has the execute permission."
    fi
  else
    echo "Error: $script_name is not present. Feature not integrated."
  fi

  # Display empty lines after executing the script
  sleep 2
}

show_menu() {
  echo "Please select an option for Installations:"
  echo "1. Install Ubuntu Dependencies"
  echo "2. Install Rancher Manager Using Helm"
  echo "3. Install Rancher Manager Using Docker"
  echo "4. Install RKE"
  echo "5. Install RKE2"
  echo "6. Install k3s"
  echo "7. Install kubectl"
  echo "8. Deploy DNS Server"
  echo "9. Uninstall All"
  echo "10. Create RKE2 Config"
  echo "11. Deploy Private Image Registry"
  echo "12. Install Docker"
  echo "13. Install Helm"
  echo "14. Exit"
  read -p "Enter your choice [1-14]: " choice
}

invalid() {
  echo "--------------------------------------"
  echo "Invalid option. Please try again."
  sleep 2
}

main
