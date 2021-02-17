set -e

INSTANCE_CONNECTION_NAME=$(terraform -chdir=infrastructure output app_db_instance_connect_name | tr -d '"')

cloud_sql_proxy -instances=$INSTANCE_CONNECTION_NAME=tcp:0.0.0.0:5432