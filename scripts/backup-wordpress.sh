#!/bin/bash

DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_DIR="/home/ubuntu/wordpress-backups"

mkdir -p "$BACKUP_DIR"

mysqldump -u wordpress_user -p'StrongPassword123!' wordpress_db > "$BACKUP_DIR/db-$DATE.sql"

tar -czf "$BACKUP_DIR/files-$DATE.tar.gz" /var/www/html

find "$BACKUP_DIR" -type f -mtime +7 -delete

echo "Backup completed: $DATE"
