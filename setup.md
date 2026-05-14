# WordPress LAMP Stack with Nginx Reverse Proxy - Setup Guide

## Prerequisites

- AWS EC2 instance: Ubuntu 22.04, t3.micro, 10GB gp3
- Security groups: Allow ports 22 (SSH), 80 (HTTP)
- SSH access configured

## 1. System Update

```bash
sudo apt update && sudo apt upgrade -y
```

## 2. Install LAMP Stack

### Apache & PHP
```bash
sudo apt install apache2 apache2-utils -y
sudo apt install php php-mysql php-gd php-cli php-common php-mbstring php-xml php-curl -y
sudo systemctl enable apache2 && sudo systemctl start apache2
```

### MySQL Server
```bash
sudo apt install mysql-server -y
sudo mysql_secure_installation
sudo systemctl enable mysql && sudo systemctl start mysql
```

## 3. Create WordPress Database

```bash
sudo mysql -u root -p << EOF
CREATE DATABASE wordpress_db;
CREATE USER 'wordpress_user'@'localhost' IDENTIFIED BY 'StrongPassword123!';
GRANT ALL PRIVILEGES ON wordpress_db.* TO 'wordpress_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
EOF
```

## 4. Download & Configure WordPress

```bash
cd /tmp
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
sudo cp -r wordpress/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html
```

Create WordPress config:
```bash
sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
```

Edit `/var/www/html/wp-config.php` with database credentials:
```
DB_NAME: wordpress_db
DB_USER: wordpress_user
DB_PASSWORD: StrongPassword123!
DB_HOST: localhost
```

## 5. Configure Apache (Port 8080)

Edit `/etc/apache2/ports.conf`:
```apache
Listen 8080
```

Create `/etc/apache2/sites-available/wordpress.conf`:
```apache
<VirtualHost *:8080>
    DocumentRoot /var/www/html
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

Enable and restart:
```bash
sudo a2ensite wordpress.conf
sudo a2dissite 000-default.conf
sudo systemctl restart apache2
```

## 6. Install & Configure Nginx Reverse Proxy

```bash
sudo apt install nginx -y
```

Create `/etc/nginx/sites-available/wordpress-reverse-proxy.conf`:
```nginx
server {
    listen 80;
    server_name _;

    access_log /var/log/nginx/wordpress_access.log;
    error_log /var/log/nginx/wordpress_error.log;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Enable and restart:
```bash
sudo ln -s /etc/nginx/sites-available/wordpress-reverse-proxy.conf /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default 2>/dev/null
sudo systemctl enable nginx && sudo systemctl restart nginx
```

## 7. Setup Automated Backups

Create `/usr/local/bin/backup-wordpress.sh`:
```bash
#!/bin/bash
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_DIR="/home/ubuntu/wordpress-backups"

mkdir -p "$BACKUP_DIR"

mysqldump -u wordpress_user -p'StrongPassword123!' wordpress_db > "$BACKUP_DIR/db-$DATE.sql"
tar -czf "$BACKUP_DIR/files-$DATE.tar.gz" /var/www/html

find "$BACKUP_DIR" -type f -mtime +7 -delete

echo "Backup completed: $DATE"
```

Make executable and schedule with cron:
```bash
sudo chmod +x /usr/local/bin/backup-wordpress.sh
sudo crontab -e
```

Add cron job:
```
0 2 * * * /usr/local/bin/backup-wordpress.sh
```

## 8. Verify Installation

```bash
# Check services
sudo systemctl status apache2
sudo systemctl status mysql
sudo systemctl status nginx

# Test connectivity
curl http://localhost:8080        # Apache directly
curl http://localhost             # Through Nginx proxy
curl http://EC2_PUBLIC_IP         # From browser
```

Access WordPress at: `http://EC2_PUBLIC_IP`

## Notes

- Apache listens on port 8080 (private)
- Nginx listens on port 80 (public)
- MySQL has public access disabled
- Daily backups at 02:00 UTC
- Backups retained for 7 days
