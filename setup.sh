#!/bin/bash

# ============================================================
# setup.sh
# ============================================================
# This script sets up the Student Progress Monitoring Dashboard database.
# It ensures the database is created, tables are structured properly, 
# functions, procedures, triggers, views, and indexes are applied,
# and environment configurations are set.
# ============================================================

# Database configuration
DB_HOST="localhost"                 # Database host (can be localhost or IP)
DB_USER="root"                      # Database username
DB_PASSWORD=""                      # Database password
DB_NAME="student_dashboard"         # Name of the database to be created

# ============================================================
# Step 1: Check Database Existence and Create If Not Exists
# ============================================================
echo "Checking if the database $DB_NAME exists..."

mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"

if [ $? -eq 0 ]; then
    echo "Database $DB_NAME created or already exists."
else
    echo "Error creating the database. Exiting."
    exit 1
fi

# Use the database
echo "Using the $DB_NAME database..."
mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD -e "USE $DB_NAME;"

# ============================================================
# Step 2: Create Tables from Schema
# ============================================================
echo "Creating tables..."

for table_sql in ./sql/02_tables/*.sql; do
    echo "Creating table from $table_sql"
    mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME < $table_sql
done

# ============================================================
# Step 3: Apply Foreign Key Constraints
# ============================================================
echo "Applying foreign key constraints..."
mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME < ./sql/03_constraints/foreign_keys.sql

# ============================================================
# Step 4: Insert Sample Data
# ============================================================
echo "Inserting sample data..."

mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME < ./sql/04_data/sample_data.sql

# ============================================================
# Step 5: Create Views
# ============================================================
echo "Creating views for performance analysis..."

for view_sql in ./sql/05_views/*.sql; do
    echo "Creating view from $view_sql"
    mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME < $view_sql
done

# ============================================================
# Step 6: Create Functions
# ============================================================
echo "Creating functions..."

for func_sql in ./sql/06_functions/*.sql; do
    echo "Creating function from $func_sql"
    mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME < $func_sql
done

# ============================================================
# Step 7: Create Stored Procedures
# ============================================================
echo "Creating stored procedures..."

for proc_sql in ./sql/07_procedures/*.sql; do
    echo "Creating procedure from $proc_sql"
    mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME < $proc_sql
done

# ============================================================
# Step 8: Create Triggers
# ============================================================
echo "Creating triggers..."

for trigger_sql in ./sql/08_triggers/*.sql; do
    echo "Creating trigger from $trigger_sql"
    mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME < $trigger_sql
done

# ============================================================
# Step 9: Apply Indexes for Performance Optimization
# ============================================================
echo "Creating indexes..."

mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME < ./sql/09_indexes/index_optimizations.sql

# ============================================================
# Step 10: Run Master SQL Script (to ensure correct order of execution)
# ============================================================
echo "Running the master SQL script for final setup..."
mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME < ./sql/10_master.sql

# ============================================================
# Step 11: Environment Configuration
# ============================================================
echo "Setting up environment variables..."

cat <<EOL > .env
DB_HOST=$DB_HOST
DB_USER=$DB_USER
DB_PASSWORD=$DB_PASSWORD
DB_NAME=$DB_NAME
EOL

echo "Environment setup complete. Configuration saved to .env."

# ============================================================
# Final Confirmation
# ============================================================
echo "Database setup complete for the Student Progress Monitoring Dashboard."
echo "All tables, functions, views, procedures, triggers, and indexes are successfully created."

# End of setup.sh script
