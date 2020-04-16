# [Beta] Invenio Helm Chart

This repository contains the helm chart to deploy an Invenio instance.

:warning: Please note that this is a work in progress, the configuration might not suit a production deployment.

## Pre-requisites

- [OpenShift Client](https://docs.openshift.com/container-platform/latest/cli_reference/openshift_cli/getting-started-cli.html#cli-installing-cli_cli-developer-commands)
- or [Kubernetes Client](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Helm, version 3.x](https://helm.sh/docs/intro/install/)

## Usage

### OpenShift

Login and select the right project:

```console
$ oc login <your.openshift.cluster>
$ oc project invenio
```

Create all the needed secrets and install Invenio.

#### 1. Secrets

Invenio secret key:

```console
$ SECRET_KEY=$(openssl rand -hex 8)
$ oc create secret generic \
  --from-literal="INVENIO_SECRET_KEY=$SECRET_KEY" \
  invenio-secrets
```

Database secrets:

```console
$ POSTGRESQL_PASSWORD=$(openssl rand -hex 8)
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
$ RABBITMQ_DEFAULT_PASS=$(openssl rand -hex 8)
$ oc create secret generic \
  --from-literal="RABBITMQ_DEFAULT_PASS=$RABBITMQ_DEFAULT_PASS" \
  --from-literal="CELERY_BROKER_URL=amqp://guest:$RABBITMQ_DEFAULT_PASS@mq:5672/" \
  mq-secrets
secret "mq-secrets" created
```

Elasticsearch secrets:

```console
$ ELASTICSEARCH_PASSWORD=$(openssl rand -hex 8)
$ ELASTICSEARCH_USER=username
$ oc create secret generic \
  --from-literal="ELASTICSEARCH_PASSWORD=$ELASTICSEARCH_PASSWORD" \
  --from-literal="ELASTICSEARCH_USER=$ELASTICSEARCH_USER" \
  elasticsearch-secrets
```

:warning: For now the previous Elasticsearch environment variables are not ported to `invenio-search`, therefore the way to create the secret is:

``` console
$ export INVENIO_SEARCH_ELASTIC_HOSTS="[{'host': 'localhost', 'timeout': 30, 'port': 9200, 'use_ssl': True, 'http_auth':('USERNAME_CHANGEME', 'PASSWORD_CHANGEME')}]"
$ oc create secret generic \
  --from-literal="INVENIO_SEARCH_ELASTIC_HOSTS=$INVENIO_SEARCH_ELASTIC_HOSTS" \
  elasticsearch-secrets
```

:warning: Note that you might need to add extra configuration to the elasticsearch hosts, sucha as vertificate verification (`verify_certs`),
prefixing (`url_prefix`) and more.

#### 2. Install Invenio

:warning: Before installing you need to configure two things, the rest are optional.
- Your host in a `values.yaml` file.
- The web/worker docker images.

``` yaml
host: yourhost.localhost

web:
  image: your/invenio-image

worker:
  image: your/invenio-image
```


**Adding a helm repository:**

``` console
$ helm repo add helm-invenio https://inveniosoftware.github.io/helm-invenio/
$ helm repo update
$ helm search invenio

NAME                   	CHART VERSION	APP VERSION	DESCRIPTION
helm-invenio/invenio	0.2.0        	1.16.0     	Open Source framework for large-scale digital repositories
helm-invenio/invenio	0.1.0        	1.16.0     	Open Source framework for large-scale digital repositories
```

Install the desired version

``` console
$ helm install invenio helm-invenio/invenio --version 0.2.0
```

**Cloning the GitHub repository:**

```console
$ git clone https://github.com/inveniosoftware/helm-invenio.git
$ cd helm-invenio/
$ helm install invenio ./invenio [--disable-openapi-validation]
NAME: invenio
LAST DEPLOYED: Mon Mar  9 16:25:15 2020
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:Invenio is ready to rock :rocket:
```

:warning: Passing `--disable-openapi-validation` as there is currently a problem with OpenShift objects and Helm when it comes to client side validation, see [issue](https://github.com/openshift/origin/issues/24060).

#### 3. Setup the instance:

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

#### 4. Launching jobs

**One time job**

``` console
$ oc process -f job.yml --param JOB_NAME='demo-data-1' \
  --param JOB_COMMAND='invenio demo create 300 1000' | oc create -f -
```

**Cron job**

``` console
$ oc process -f cronjob.yml --param JOB_NAME=index-run \
  --param JOB_COMMAND=invenio index run -d | oc create -f -
```

### Kubernetes

The login to your Kubernetes cluster depends to your provider. For the purpose of this introduction we also assume your provider created a namespace for your InvenioRDM project.

Create all the needed secrets and install Invenio.

#### 1. Secrets

Invenio secret key:

```console
$ SECRET_KEY=$(openssl rand -hex 8)
$ kubectl create secret generic \
  --from-literal="INVENIO_SECRET_KEY=$SECRET_KEY" \
  invenio-secrets --namespace invenio
```

Database secrets:

```console
$ POSTGRESQL_PASSWORD=$(openssl rand -hex 8)
$ POSTGRESQL_USER=invenio
$ POSTGRESQL_HOST=db
$ POSTGRESQL_PORT=5432
$ POSTGRESQL_DATABASE=invenio
$ kubectl create secret generic \
  --from-literal="POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD" \
  --from-literal="SQLALCHEMY_DB_URI=postgresql+psycopg2://$POSTGRESQL_USER:$POSTGRESQL_PASSWORD@$POSTGRESQL_HOST:$POSTGRESQL_PORT/$POSTGRESQL_DATABASE" \
  db-secrets --namespace invenio
secret "db-secrets" created
```

RabbitMQ secrets:

```console
$ RABBITMQ_DEFAULT_PASS=$(openssl rand -hex 8)
$ kubectl create secret generic \
  --from-literal="RABBITMQ_DEFAULT_PASS=$RABBITMQ_DEFAULT_PASS" \
  --from-literal="CELERY_BROKER_URL=amqp://guest:$RABBITMQ_DEFAULT_PASS@mq:5672/" \
  mq-secrets --namespace invenio
secret "mq-secrets" created
```

Elasticsearch secrets:

```console
$ ELASTICSEARCH_PASSWORD=$(openssl rand -hex 8)
$ ELASTICSEARCH_USER=username
$ kubectl create secret generic \
  --from-literal="ELASTICSEARCH_PASSWORD=$ELASTICSEARCH_PASSWORD" \
  --from-literal="ELASTICSEARCH_USER=$ELASTICSEARCH_USER" \
  elasticsearch-secrets --namespace invenio
```

:warning: For now the previous Elasticsearch environment variables are not ported to `invenio-search`, therefore the way to create the secret is:

``` console
$ export INVENIO_SEARCH_ELASTIC_HOSTS="[{'host': 'localhost', 'timeout': 30, 'port': 9200, 'use_ssl': True, 'http_auth':('USERNAME_CHANGEME', 'PASSWORD_CHANGEME')}]"
$ kubectl create secret generic \
  --from-literal="INVENIO_SEARCH_ELASTIC_HOSTS=$INVENIO_SEARCH_ELASTIC_HOSTS" \
  elasticsearch-secrets --namespace invenio
```

:warning: Note that you might need to add extra configuration to the elasticsearch hosts, sucha as certificate verification (`verify_certs`),
prefixing (`url_prefix`) and more.

Docker secrets:

As you're working in a cloud environment and don't know to which node the image is pulled, you have to define an `imagePullSecret`:

``` console
$ kubectl create secret docker-registry regsecret \
  --docker-server=DOCKERHOST_CHANGEME --docker-username=DOCKERUSER_CHANGEME \ 
  --docker-password=DOCKERPASSWORD_CHANGEME --docker-email=EMAIL_CHANGE_ME --namespace invenio
```

#### 2. Install Invenio

:warning: Before installing you need to configure two things, the rest are optional.
- Your host in a `values.yaml` file.
- The web/worker docker images.

``` yaml
host: yourhost.localhost

web:
  image: your/invenio-image
  imagePullSecret: your/image-pull-secret

worker:
  image: your/invenio-image
  imagePullSecret: your/image-pull-secret
```


**Cloning the GitHub repository:**

```console
$ git clone https://github.com/inveniosoftware/helm-invenio.git
$ cd helm-invenio/
$ helm install invenio ./invenio-k8s --namespace invenio [--disable-openapi-validation]
NAME: invenio
LAST DEPLOYED: Mon Mar  9 16:25:15 2020
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:Invenio is ready to rock :rocket:
```

:warning: Passing `--disable-openapi-validation` as there is currently a problem with OpenShift objects and Helm when it comes to client side validation, see [issue](https://github.com/openshift/origin/issues/24060).

#### 3. Setup the instance:

Get a bash terminal in a pod:

```console
$ kubectl get pods --namespace invenio
$ kubectl exec -it <web-pod> bash --namespace invenio
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
$ invenio rdm-records demo
```
