# [Beta] Invenio Helm chart: OpenShift specifics

1. [Cluster login](#cluster-login)
2. [Secret management](#secret-management)
3. [Instance setup](#instance-setup)
4. [Job management](#job-management)

## Pre-requisites

- [OpenShift Client](https://docs.openshift.com/container-platform/latest/cli_reference/openshift_cli/getting-started-cli.html#cli-installing-cli_cli-developer-commands)

## Cluster login

Login and select the right project:

```console
$ oc login <your.openshift.cluster>
$ oc project invenio
```

Create all the needed secrets and install Invenio.

## Secret management

Invenio secret key:

```console
$ SECRET_KEY=$(openssl rand -hex 50)
$ SECURITY_LOGIN_SALT=$(openssl rand -hex 128)
$ CSRF_SECRET_SALT=$(openssl rand -hex 128)
$ oc create secret generic \
  --from-literal="INVENIO_SECRET_KEY=$SECRET_KEY" \
  --from-literal="INVENIO_SECURITY_LOGIN_SALT=$SECURITY_LOGIN_SALT" \
  --from-literal="INVENIO_CSRF_SECRET_SALT=$CSRF_SECRET_SALT" \
    invenio-secrets
```

Database secrets:

```console
$ read POSTGRESQL_PASSWORD
$ POSTGRESQL_USER=invenio
$ POSTGRESQL_HOST=db
$ POSTGRESQL_PORT=5432
$ POSTGRESQL_DATABASE=invenio
$ oc create secret generic \
  --from-literal="POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD" \
  --from-literal="SQLALCHEMY_DB_URI=postgresql+psycopg2://$POSTGRESQL_USER:$POSTGRESQL_PASSWORD@$POSTGRESQL_HOST:$POSTGRESQL_PORT/$POSTGRESQL_DATABASE" \
  db-secrets
secret "db-secrets" created
```

RabbitMQ secrets:

```console
$ RABBITMQ_DEFAULT_PASS=$(openssl rand -hex 16)
$ oc create secret generic \
  --from-literal="RABBITMQ_DEFAULT_PASS=$RABBITMQ_DEFAULT_PASS" \
  --from-literal="CELERY_BROKER_URL=amqp://guest:$RABBITMQ_DEFAULT_PASS@mq:5672/" \
  mq-secrets
secret "mq-secrets" created
```

HaProxy secrets:

```console
$ read HAPROXY_USERNAME
$ HAPROXY_PSW=$(openssl rand -hex 16)
$ oc create secret generic \
  --from-literal="stats-username=$HAPROXY_USERNAME" \
  --from-literal="stats-password=$HAPROXY_PSW" \
  haproxy-secrets
secret "haproxy-secrets" created
```

sentry secrets:

```
$ read SENTRY_DSN
$ oc create secret generic \
  --from-literal="SENTRY_DSN=$SENTRY_DSN" \
    sentry-secrets
```

datacite secrets:

```
$ read DATACITE_USERNAME
$ read DATACITE_PASSWORD
$ oc create secret generic \
  --from-literal="DATACITE_USERNAME=$DATACITE_USERNAME" \
  --from-literal="DATACITE_PASSWORD=$DATACITE_PASSWORD" \
    datacite-secrets
```

pgbouncer secrets:

```
$ cat > pgbouncer_auth_file << EOF
invenio: xxxverysecretscrampasswordxxx
EOF

$ oc create secret generic \
  --from-file=auth_file=pgbouncer_auth_file \
  pgbouncer
```

search secrets:

```console
$ read SEARCH_USER
$ read SEARCH_PASSWORD
$ SEARCH_HOST=search
$ SEARCH_PORT=9200
$ oc create secret generic \
  --from-literal="INVENIO_SEARCH_HOSTS=[{'host': '$SEARCH_HOST', 'timeout': 30, 'port': $SEARCH_PORT, 'use_ssl': True, 'http_auth':('$SEARCH_USER', '$SEARCH_PASSWORD')}]" \
  search-secrets
```

:note: Note that you might need to add extra configuration to the
search hosts, such as certificate verification (`verify_certs`),
prefixing (`url_prefix`) and more.

:warning: The provided configuration of OpenSearch is for demo only and **it should
not be used in production**. Please refer to the [official OpenSearch Helm charts](https://opensearch.org/docs/latest/opensearch/install/helm/) for a production deployment.

## Instance setup

Get a bash terminal in a pod:

```console
$ oc get pods
$ oc exec -it <web-pod> bash
```

Setup the instance:

``` console
$ . scl_source enable rh-python36
$ invenio db init # If the db does not exist already
$ invenio db create
$ invenio index init
$ invenio index queue init purge
$ invenio files location --default 'default-location'  $(invenio shell --no-term-title -c "print(app.instance_path)")'/data'
$ invenio roles create admin
$ invenio access allow superuser-access role admin
```

## Job management

### One time job

``` console
$ oc process -f job.yml --param JOB_NAME='demo-data-1' \
  --param JOB_COMMAND='invenio demo create 300 1000' | oc create -f -
```

### Cron job

``` console
$ oc process -f cronjob.yml --param JOB_NAME=index-run \
  --param JOB_COMMAND=invenio index run -d | oc create -f -
```
