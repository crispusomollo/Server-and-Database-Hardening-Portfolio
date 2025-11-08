-- Remove anonymous users
DELETE FROM mysql.user WHERE User='';

-- Disable remote root access
UPDATE mysql.user SET Host='localhost' WHERE User='root';

-- Create a user with limited privileges
CREATE USER 'app_user'@'localhost' IDENTIFIED BY 'StrongPassword123!';
GRANT SELECT, INSERT, UPDATE ON myapp.* TO 'app_user'@'localhost';
FLUSH PRIVILEGES;

