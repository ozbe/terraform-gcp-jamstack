set -e

DB_NAME=$(terraform -chdir=infrastructure output app_db_name | tr -d '"')
USER=$(terraform -chdir=infrastructure output app_db_user | tr -d '"')

psql "host=127.0.0.1 sslmode=disable dbname=$DB_NAME user=$USER"