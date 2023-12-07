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
2. Install Rancher Manager Using Helm
3. Install Rancher Manager Using Docker
4. Install RKE
5. Install RKE2
6. Install k3s
7. Install kubectl
8. Deploy DNS Server
9. Uninstall All
10. Create RKE2 Config
11. Deploy Private Image Registry
12. Install Docker
13. Install Helm
14. Exit

Make sure to review the script documentation for any additional details or customization options for each task.
