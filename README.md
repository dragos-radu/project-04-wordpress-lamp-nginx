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