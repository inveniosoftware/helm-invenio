# [Beta] Invenio Kubernetes Helm chart

The login to your Kubernetes cluster depends to your provider. For the purpose of this introduction we also assume your provider created a namespace for your InvenioRDM project.

## Running Invenio

### 1. Secrets

:warning: Most secrets are created automatically through the default `values` file. It's however **strongly advised** to override them 
(either through a value file or through the `--set` flag), especially if running anything else than a private test environment.
Just enter your secret's name(s) in your own `values` file.

#### Docker secrets

As you're working in a cloud environment and don't know to which node the image is pulled, you have to define an `imagePullSecret`:

```bash
kubectl create secret docker-registry regsecret \
  --docker-server=DOCKERHOST_CHANGEME --docker-username=DOCKERUSER_CHANGEME \ 
  --docker-password=DOCKERPASSWORD_CHANGEME --docker-email=EMAIL_CHANGE_ME --namespace invenio
```

Remember how you named it, it will be used in the next section

### 2. Installing Invenio

#### Values

Before installing you need to configure a few things in a `values-overrides.yaml` file.

* Bare minimum (:warning: **insecure**, for local testing only):
```yaml
host: yourhost.localhost

web:
  image: your/invenio-image
  imagePullSecret: your/image-pull-secret

worker:
  image: your/invenio-image
  imagePullSecret: your/image-pull-secret

ingress:
  sslSecretName: your-ssl-secret
```

* If demo set or pre-set users are desired, add:
```yaml
invenio:
  init: true  # initiates db, index, and admin roles
  demo_data: true  # for a demo set of records
  default_users:  # for creating users on install
    "user@example.com": "password"
```

* Recommended (enhanced security :white-check_mark:), add:

```yaml
# --- Secrets below
invenio:
  secret-key: "my-very-safe-secret"

rabbitmq:
  default_password: "mq_password"
  # Edit the following URI with the values from just above
  celery_broker_uri: "amqp://guest:mq_password@mq:5672/"

postgresql:
  user: "invenio"
  password: "db_password"
  host: "db"
  port: "5432"
  database: "invenio"
  # Edit the following URI with the values from just above
  sqlalchemy_db_uri: "postgresql+psycopg2://invenio:db_password@db:5432/invenio"
```


For a complete list of values, see the [Configuration](#configuration) section

:lock: For security concerns, you may want to not have the credentials lying around the values file. A suggestion is made in the next section.

#### Installing the chart

First, clone the GitHub repository and change directory:
```bash
git clone https://github.com/inveniosoftware/helm-invenio.git
cd helm-invenio/
```

Then proceed to the installation
```bash
helm install -f values-overrides.yaml invenio ./invenio-k8s --namespace invenio 
# NAME: invenio
# LAST DEPLOYED: Mon Mar  9 16:25:15 2020
# NAMESPACE: default
# STATUS: deployed
# REVISION: 1
# TEST SUITE: None
# NOTES:Invenio is ready to rock :rocket:
```

:lock: If you are worried about the credentials lying around in the values file, you could take inspiration from this installation command instead:
```bash
DB_PASSWORD=$(openssl rand -hex 8)
helm install -f safe-values.yaml --set postgresql.password=$DB_PASSWORD invenio ./invenio-k8s --namespace invenio
```

As precised in the [official documentation](https://helm.sh/docs/helm/helm_install/), multiple values and/or `--set` flags can be used in the same command line.

### 3. Performing operations on your instance

Get a bash terminal in a pod:

```bash
kubectl get pods --namespace invenio
kubectl exec -it <web-pod> bash --namespace invenio  # <web-pod> is found with the previous command
```

Then you can run invenio commands such as:

```bash
. scl_source enable rh-python36
invenio db init # If the db does not exist already
invenio db create
invenio index init
invenio index queue init purge
invenio files location --default 'default-location'  $(invenio shell --no-term-title -c "print(app.instance_path)")'/data'
invenio roles create admin
invenio access allow superuser-access role admin
invenio rdm-records demo
```


## Configuration
The following table lists the configurable parameters of the `invenio` chart and their default values, and can be overwritten via the helm `--set` flag.

Parameter | Description | Default
---                                             | ---       | ---
`host` | Your hostname | `yourhost.localhost`
`invenio.secret_key` | The invenio secret key; **set it**! | `secret-key`
`invenio.init` | Whether to initiate database, index and roles | `false`
`invenio.default_users` | If set, create users identified by email:password on install (only works if init=true) | `nil`
`invenio.demo_data` | Whether to create demo data on install (only works if init=true and if `default_users` isn't empty) | `false`
`ingress.enabled` | Whether to enable ingress | `true`
`ingress.class` | Class of the ingress if enabled | `nginx-internal`
`ingress.sslSecretName` | The ingress ssl secret for HTTPS | `your-ssl-secret`
`haproxy.inside_cluster` | Whether to enable haproxy workers inside the cluster | `false`
`haproxy.maxconn` | Number of maximum connections to haproxy workers | `100`
`nginx.max_conns` | Number of maximum connections to the nginx workers | `100`
`nginx.assets.location` | Mount point of the assets | `/opt/invenio/var/instance/static`
`web.image` | Image to use for the invenio web pods | `your/invenio-image`
`web.imagePullSecret` | Secrets to use to pull the invenio web pods | `your/image-pull-secret`
`web.replicas` | Number of replicas for the invenio web pods | `6`
`web.uwsgi.processes` | Number of uwsgi process for the web pods | `6`
`web.uwsgi.threads` | Number of uwsgi threads for the web pods | `4`
`web.autoscaler.enabled` | Should the Horizontal Pod Autoscaler (HPA) be enabled for the web pods | `false`
`web.autoscaler.scaler_cpu_utilization` | CPU utilization threshold for the web HPA  | `65`
`web.autoscaler.max_web_replicas` | Max number of replicas for the web HPA | `10`
`web.autoscaler.min_web_replicas` | Min number of replicas for the web HPA | `2`
`web.assets.location` | Location of the assets | `/opt/invenio/var/instance/static`
`worker.enabled` | Whether to enable the invenio workers | `true`
`worker.image` | Image to use for the invenio worker pods | `your/invenio-image`
`worker.imagePullSecret` | Secrets to use to pull the invenio worker pods | `your/image-pull-secret`
`worker.app` | App used by the celery command | `invenio_app.celery`
`worker.concurrency` | Concurrency used in the celery command | `2`
`worker.log_level` | Logging level in the invenio worker | `INFO`
`worker.replicas` | Number of replicas for the invenio worker pods | `2`
`redis.inside_cluster` | Whether to enable redis within the cluster | `true`
`rabbitmq.inside_cluster` | Whether to enable rabbitmq within the cluster | `true`
`rabbitmq.default_password` | The rabbitmq password | `mq_password`
`rabbitmq.celery_broker_uri` | The celery broker URL | `amqp://guest:mq_password@mq:5672/`
`postgresql.inside_cluster` | Whether to enable postgresql within the cluster | `true`
`postgresql.user` | The postgresql user | `invenio`
`postgresql.password` | The postgresql password | `db_password`
`postgresql.host` | The postgresql host name | `db`
`postgresql.port` | The postgresql port | `5432`
`postgresql.database` | The postgresql database name | `invenio`
`postgresql.sqlalchemy_db_uri` | The postgresql DB URI | `postgresql+psycopg2://invenio:db_password@db:5432/invenio`
`elasticsearch.inside_cluster` | Whether to enable Elastic Search within the cluster | `true`
`elasticsearch.invenio_hosts` | The Elastic Search hosts as used by invenio | `[{'host': 'es'}]`
`elasticsearch.user` | [Unimplemented] The Elastic Search username | `username`
`elasticsearch.password` | [Unimplemented] The Elastic Search password | `password`
`logstash.enabled` | Whether to enable Logstash within the cluster | `false`
`logstash.filebeat_image` | The Filebeat image Logstash uses | `filebeat_image_to_be_used` 
`logstash.environment` | The environment Logstash uses | `qa`
