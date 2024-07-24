
# devopsfetch Installation and Configuration Guide


Devopsfetch is a tool designed for server information retrieval and monitoring. It collects and displays system information such as active ports, user logins, Nginx configurations, Docker images, and container statuses. Additionally, a systemd service is implemented to continuously monitor and log these activities.
## PREREQUISITE
* An Ubuntu server (or any Linux server that supports systemd)
* Docker installed and running on your server
* Basic knowledge of Linux commands and system administration
## OVERVIEW
The install.sh script automates the setup of the devopsfetch tool on a Linux system. It updates the package list, installs the net-tools package, copies the devopsfetch script to the appropriate directory for executable files, and ensures it has the correct permissions.

 The script then sets up a systemd service by copying the service configuration file to the systemd directory and enabling and starting the service to ensure it runs automatically at boot.

The devopsfetch.service file is a systemd service unit configuration. It describes the devopsfetch monitoring service, specifying that it should start after the network is up, run the devopsfetch script, and automatically restart if it fails. 

Output and error logs are redirected to specific files, and the service runs under the ubuntu user and group. 

The service is configured to be active during the system's multi-user runlevel, making it part of the normal system operation.
## Installation

```
#!/bin/bash

# Install necessary packages
sudo apt update
sudo apt install -y net-tools
# Copy devopsfetch script to /usr/local/bin
sudo cp devopsfetch.sh /usr/local/bin/devopsfetch
sudo chmod +x /usr/local/bin/devopsfetch
```
* Updates the list of available packages
* Installs the net-tools package, which includes utilities like ifconfig and netstat.
* Copies the devopsfetch.sh script to /usr/local/bin and renames it to devopsfetch.
* Makes the devopsfetch script executable.

install.sh script continuation
```
# Set up systemd service
sudo cp devopsfetch.service /etc/systemd/system/devopsfetch.service
sudo systemctl enable devopsfetch.service
sudo systemctl start devopsfetch.service

echo "Installation complete. Use 'sudo systemctl status devopsfetch' to check service status."
```
setup the systemd service
* Copies the devopsfetch.service file to the systemd service directory, making it available to systemd.
* Enables the devopsfetch service, so it will start automatically on boot.
* Starts the devopsfetch service immediately.
* Prints a message indicating that the installation is complete and provides a command to check the service status.

Run the `install.sh` script 

```
./install.sh
```

The `devopsfetch.service `script

The devopsfetch.service script is used to create a systemd service for running the devopsfetch tool. 

This service ensures that devopsfetch runs automatically on system startup and can be managed using systemd commands.
```
[Unit]
Description=DevOpsFetch Monitoring Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/devopsfetch
Restart=on-failure
StandardOutput=file:/var/log/devopsfetch.log
StandardError=file:/var/log/devopsfetch.err
User=ubuntu
Group=ubuntu

[Install]
WantedBy=multi-user.target
```
* Defines the unit configuration for the service.
* Provides a brief description of the service for informational purposes.
* Specifies that this service should start after the network is available.
* Defines the service-specific settings.
* Specifies the command to execute to start the service.
* Configures the service to restart automatically if it fails.
* Redirects the standard output (stdout) of the service to a specified log file.
* Redirects the standard error (stderr) of the service to a specified log file.



## Usage/Examples



## Usage
* Command-Line Flags

* "-p" or "--port": Display all active ports and services or provide detailed information about a specific port.
```
devopsfetch -p
devopsfetch -p 80
```
* "-d" or "--docker": List all Docker images and containers, or provide detailed information about a specific container.
```
devopsfetch -d
devopsfetch -d <container_name>
```
* -n or --nginx: Display all Nginx domains and their ports, or provide detailed configuration information for a specific domain.
```
devopsfetch -n
devopsfetch -n <domain>
```
* -u or --users: List all users and their last login times, or provide detailed information about a specific user.
```
devopsfetch -u
devopsfetch -u <username>
```
* -t or --time: Display activities within a specified time range.
```
devopsfetch -t "start_time end_time"
```
* -h or --help: Display usage instructions for the program.
```
devopsfetch -h
```
### Logging Mechanism for devopsfetch

The devopsfetch tool uses a logging mechanism to track its activities and operations. 
This guide explains how logging is configured and how you can retrieve and manage the logs effectively.

```
/var/log/devopsfetch.log {
    daily
    rotate 7
    compress
    missingok
    notifempty
    create 666 root root
    postrotate
        systemctl restart devopsfetch.service > /dev/null 2>&1 || true
    endscript
}
```

The logs for devopsfetch are stored in the file located at `/var/log/devopsfetch.log`

* Log Rotation Configuration
To manage the size of the log file and ensure it does not consume excessive disk space, log rotation is configured. 

The log rotation settings are defined in a configuration file, typically located in /etc/logrotate.d/ (e.g., /etc/logrotate.d/devopsfetch).

`daily`: The log file will be rotated every day.

`rotate 7`: Keeps 7 rotated log files before deleting the oldest ones.

`compress`: Rotated log files will be compressed to save space.

`missingok`: If the log file is missing, the rotation will not fail.

`notifempty`: Do not rotate the log file if it is empty.

`create 666 root root`: New log files will be created with permissions 666 and owned by root user and group.

`postrotate`: After rotation, the devopsfetch service will be restarted to start logging to a new file. Any errors during the restart will be suppressed.

`endscript`: Marks the end of the post-rotation script

* Retrieving Logs
To view the logs, you can use various command-line tools. Here’s how to access and manage the devopsfetch logs:
```
sudo tail -f /var/log/devopsfetch.log
```
This command will continuously display new log entries as they are added to the file.

* View Recent Logs
To view the most recent entries in the log file, use the tail command
```
sudo cat /var/log/devopsfetch.log
```

