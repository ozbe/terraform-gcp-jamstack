## Cloud SQL Proxy

**NOTE** This may prove helpful for the backend migrations

```
$ gcloud auth configure-docker -q

BUCKET=$(terraform -chdir=infrastructure output app_db_instance_connect_name | tr -d '"')

$ INSTANCE_CONNECTION_NAME=$(terraform -chdir=infrastructure output app_db_instance_connect_name | tr -d '"')
$ DB_NAME=$(terraform -chdir=infrastructure output app_db_name | tr -d '"')
$ USER=$(terraform -chdir=infrastructure output app_db_user | tr -d '"')
$ PGPASSWORD=$(terraform -chdir=infrastructure output app_db_password | tr -d '"')

$ docker pull gcr.io/cloudsql-docker/gce-proxy:1.19.1

$ docker run -it \
  -v ~/.config:/usr/65532/.config:ro \
  -p 127.0.0.1:5432:5432 \
  gcr.io/cloudsql-docker/gce-proxy:1.19.1 /cloud_sql_proxy \
  -instances=$INSTANCE_CONNECTION_NAME=tcp:0.0.0.0:5432

psql "host=127.0.0.1 sslmode=disable dbname=$DB_NAME user=$USER"


```