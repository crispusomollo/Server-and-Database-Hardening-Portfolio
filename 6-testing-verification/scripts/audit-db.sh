#!/bin/bash
echo "Checking PostgreSQL user roles..."
sudo -u postgres psql -c "\du"

echo "Checking MySQL users..."
sudo mysql -e "SELECT User, Host FROM mysql.user;"

echo "MongoDB users (requires mongo shell)..."
# mongo --eval "db.getUsers()"

