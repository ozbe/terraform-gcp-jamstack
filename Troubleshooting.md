## Cloud SQL Proxy

**NOTE** This may prove helpful for the backend migrations

```
$ gcloud auth configure-docker -q

$ INSTANCE_CONNECTION_NAME=$()
$ USER=$()
$ PGPASSWORD=$()

$ docker pull gcr.io/cloudsql-docker/gce-proxy:1.19.1

docker run -d \
  -v ~/.config/gcloud:/root/.config/gcloud
  -p 127.0.0.1:5432:5432 \
  gcr.io/cloudsql-docker/gce-proxy:1.19.1/cloud_sql_proxy \
  -instances=$INSTANCE_CONNECTION_NAME=tcp:0.0.0.0:5432

psql -U $USER -p -h 127.0.0.1

```