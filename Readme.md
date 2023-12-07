Easy Install

This project does automated installaion and helps you with other deployments.

## Getting Started

To run this project locally, follow these steps:

1. Clone the repository:

    ```bash
    git clone https://github.com/khushalchandak17/auto_script_install.git
    ```

2. Make the installation scripts executable:

    ```bash
    chmod +x auto_script_install/main.sh auto_script_install/data/*
    ```

3. Run the main installation script:

    ```bash
    ./auto_script_install/main.sh
    ```

This will clone the repository and make the necessary sub-scripts executable, allowing you to run the main installation script.


This will perform the following set of tasks:

1. Install Ubuntu Dependencies
2. Install CenOs-dependencies
3. Install Fedora or other OS dependencies
4. Install Rancher Manager Using Helm
5. Install Rancher Manager Using Docker
6. Install RKE
7. Install RKE2
8. Install k3s
9. Install kubectl
10. Deploy DNS Server
11. Uninstall All
12. Create RKE2 Config
13. Deploy Private Image Registry
14. Install Docker
15. Install Helm
16. Configure HA-Proxy or Nginx
17. Configure proxy usqing Squid
18. Install containerd
19. install cri-o
20. Exit

Make sure to review the script documentation for any additional details or customization options for each task.
