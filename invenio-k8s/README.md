## Configuration
The following table lists the configurable parameters of the `invenio-k8s` chart and their default values, and can be overwritten via the helm `--set` flag.

Parameter | Description | Default
---                                             | ---       | ---
`host` | Your hostname | `yourhost.localhost`
`invenio.secret_key` | The invenio secret key; **set it**! | `secret-key`
`invenio.demo_data` | Whether to create demo data on install | `false`
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
`rabbitmq.celery_broker_url` | The celery broker URL | `amqp://guest:mq_password@mq:5672/`
`postgresql.inside_cluster` | Whether to enable postgresql within the cluster | `true`
`postgresql.user` | The postgresql user | `invenio`
`postgresql.password` | The postgresql password | `db_password`
`postgresql.host` | The postgresql host name | `db`
`postgresql.port` | The postgresql port | `5432`
`postgresql.database` | The postgresql database name | `invenio`
`postgresql.sqlalchemy_db_uri` | The postgresql DB URI | `postgresql+psycopg2://invenio:db_password@db:5432/invenio`
`elasticsearch.inside_cluster` | Whether to enable Elastic Search within the cluster | `true`
`elasticsearch.user` | The Elastic Search username | `username`
`elasticsearch.password` | The Elastic Search password | `password`
`elasticsearch.invenio_hosts` | The Elastic Search hosts as used by invenio | `[{'host': 'es'}]`
`logstash.enabled` | Whether to enable Logstash within the cluster | `false`
`logstash.filebeat_image` | The Filebeat image Logstash uses | `filebeat_image_to_be_used` 
`logstash.environment` | The environment Logstash uses | `qa`
