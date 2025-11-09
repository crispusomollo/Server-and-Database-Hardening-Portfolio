#!/bin/bash

# PostgreSQL database backup script
# Backup directory
BACKUP_DIR="/var/backups/postgresql"
DATE=$(date +%F_%H-%M)
DB_NAME="your_db_name"
USER="postgres"

# Ensure backup directory exists
mkdir -p $BACKUP_DIR

# Dump the database
pg_dump -U $USER $DB_NAME | gzip > "$BACKUP_DIR/${DB_NAME}_$DATE.sql.gz"

# Remove backups older than 7 days
find $BACKUP_DIR -type f -name "*.sql.gz" -mtime +7 -delete

echo "[$(date)] Backup complete: ${DB_NAME}_$DATE.sql.gz"

# ==== MySQL Backup ====

# Variables
MYSQL_USER="root"
MYSQL_PASS="yourpassword"
MYSQL_DB="your_mysql_db"
MYSQL_BACKUP_DIR="/var/backups/mysql"
DATE=$(date +%F_%H-%M)

# Create dir
mkdir -p $MYSQL_BACKUP_DIR

# Backup
mysqldump -u$MYSQL_USER -p$MYSQL_PASS $MYSQL_DB | gzip > "$MYSQL_BACKUP_DIR/${MYSQL_DB}_$DATE.sql.gz"

# Clean old
find $MYSQL_BACKUP_DIR -type f -name "*.sql.gz" -mtime +7 -delete

echo "[$(date)] MySQL backup complete: ${MYSQL_DB}_$DATE.sql.gz"

# Ensure mysqldump is installed
