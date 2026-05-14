# Project 04 – WordPress LAMP Stack with Nginx Reverse Proxy on AWS

## Jira Epic

DEVOPS-13 – Deploy WordPress LAMP Stack

## Goal

Deploy a dynamic WordPress application on AWS using a LAMP stack and Nginx as a reverse proxy.

## Architecture

Client -> Nginx :80 -> Apache :8080 -> PHP / WordPress -> MySQL

## Tech Stack

- AWS EC2
- Ubuntu 22.04
- Apache
- MySQL
- PHP
- WordPress
- Nginx
- Bash
- Cron

## Repository Structure

```text
project-04-wordpress-lamp-nginx/
├── scripts/
├── nginx/
├── apache/
├── screenshots/
├── architecture/
├── README.md
└── setup.md
```

## Project Status

In progress

## AWS EC2

- Region: eu-central-1
- AMI: Ubuntu 22.04
- Instance type: t3.micro
- Storage: 10 GB gp3
- Public ports: 22, 80
- MySQL public access: disabled

## LAMP Stack

Installed components:

- Apache
- MySQL
- PHP
- WordPress PHP extensions

Validation:

- Apache service active
- MySQL service active
- PHP tested with phpinfo

## WordPress Database

- Database: wordpress_db
- User: wordpress_user
- Host: localhost
- Public MySQL access: disabled

## Reverse Proxy

- Nginx listens on port 80
- Apache listens on port 8080
- Nginx forwards traffic to Apache
- WordPress runs from /var/www/html

## Backups

- Backup script: /usr/local/bin/backup-wordpress.sh
- Backup location: /home/ubuntu/wordpress-backups
- Database backup: mysqldump
- Files backup: tar.gz archive
- Schedule: daily at 02:00 using cron
- Retention: 7 days