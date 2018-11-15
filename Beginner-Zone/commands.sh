#Login and run query about create databases, tables
mysql -u root -p < all_schema.sql

#Login and run query to fill catalogs
mysql -u root -p -D library < all_data.sql

#Create Backup for Database
mysqldump -u root -p library > backup.sql

#Create Schema Backup for Database, flag -d is equal to say 'without data'
mysqldump -u root -p -d library > backup-schema.sql
