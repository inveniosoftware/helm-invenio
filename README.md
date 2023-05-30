# [Beta] Invenio Helm Chart

This repository contains the helm chart to deploy an Invenio instance.

:warning: Please note that this configuration is not meant to be used in production.
This configuration should be adapted and hardened depending on your infrastructure and
constraints.

1. [Pre-requisites](#pre-requisites)
2. [Configuration](#configuration)
3. [Secret management](#secret-management)
4. [Deploy your instance](#deploy-your-instance)

## Pre-requisites

- [Helm, version 3.x](https://helm.sh/docs/intro/install/)

Depending on the underlying technology, pre-requisites and configuration might
change.

- [Kubernetes](README-Kubernetes.md)
- [OpenShift](README-OpenShift.md)

## Configuration

:warning: Before installing you need to configure two things in your
`values.yaml` file.

- Host
- The web/worker docker images. If you need credentials you can see how to set
  them up in [Kubernetes](README-Kubernetes/#docker-credentials).

``` yaml
host: yourhost.localhost

web:
  image: your/invenio-image

worker:
  image: your/invenio-image
```

The following table lists the configurable parameters of the `invenio` chart and their
default values, and can be overwritten via the helm `--set` option.

### General

 Parameter | Description   | Default              
-----------|---------------|----------------------
 `host`    | Your hostname | `yourhost.localhost` 

### Invenio

 Parameter                                           | Description                                                                                                           | Default               
-----------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------|-----------------------
 `invenio.secret_key`                                | The Invenio secret key used for encryption; **set it**!                                                               | `secret-key`          
 `invenio.security_login_salt`                       | The Invenio salt value, used when generating login links/tokens; **set it**!                                          | `security_login_salt` 
 `invenio.csrf_secret_salt`                          | The Invenio salt value, used when generating login CSRF tokens; **set it**!                                           | `csrf_secret_salt`    
 `invenio.init`                                      | Whether to initiate database, index and roles                                                                         | `false`               
 `invenio.default_users`                             | If set, create users identified by email:password on install (only works if init=true)                                | `nil`                 
 `invenio.demo_data`                                 | Whether to create demo data on install (only works if init=true and if `default_users` isn't empty)                   | `false`               
 `invenio.sentry.enabled`                            | Enable Sentry logging                                                                                                 | `false`               
 `invenio.sentry.existing_secret`                    | Whether to use an existing secret or create a new one                                                                 | `false`               
 `invenio.sentry.secret_name`                        | Name of the secret to use or create                                                                                   | `sentry-secrets`      
 `invenio.sentry.dsn`                                | DSN for sentry                                                                                                        | `""`                  
 `invenio.datacite.enable`                           | Enable DataCite provider                                                                                              | `false`               
 `invenio.datacite.existing_secret`                  | Whether to use an existing secret or create a new one                                                                 | `false`               
 `invenio.datacite.secret_name`                      | Name of the secret to use or create                                                                                   | `datacite-secrets`    
 `invenio.remote_apps.enabled`                       | Enable logging with remote applications                                                                               | `false`               
 `invenio.remote_apps.existing_secret`               | Whether to use an existing secret or create a new one                                                                 | `false`               
 `invenio.remote_apps.secret_name`                   | Name of the secret to use or create                                                                                   | `remote-apps-secrets` 
 `invenio.remote_apps.credentials`                   | List of remote applications' credentials (name, consume_key, consumer_secret)                                         | `""`                  
 `invenio.extra_config`                              | List of key:value configuration variables accepted by the python application                                          | `""`                  
 `invenio.file_config_maps`                          | List of objects describing additional config maps read from file                                                      | `""`                  
 `invenio.file_config_maps.<configMapName>.fileName` | Name of the file config map                                                                                           | `""`                  
 `invenio.file_config_maps.<configMapName>.file`     | File content (should be loaded by --set-file invenio.file_config_maps.<configMapName>.file=<path-to-my-file>  option) | `""`                  
 `invenio.file_config_maps.<configMapname>`          | Config map name                                                                                                       | `""`                  
 `invenio.extra_env_from_secret`                                 | List of objects describing extra environment variables to be passed to the app                                        | `""`                  
 `invenio.extra_env_from_secret.<0>.name`                        | Secret name                                                                                                           | `""`                  
 `invenio.extra_env_from_secret.<0>.valueFrom.secretKeyRef.name` | Secret variable name to be passed to the app                                                                          | `""`                  
 `invenio.extra_env_from_secret.<0>.valueFrom.secretKeyRef.key`  | Secret variable key to be passed to the app                                                                           | `""`                  

### HAProxy

 Parameter                | Description                                          | Default       
--------------------------|------------------------------------------------------|---------------
 `haproxy.enabled`        | Whether to enable haproxy workers inside the cluster | `false`       
 `haproxy.image`          | Image to use for HaProxy                             | `haproxy:2.2` 
 `haproxy.maxconn`        | Number of maximum connections to backend             | `100`         
 `haproxy.maxconn_static` | Number of maximum connections to static files        | `500`         

### Nginx

 Parameter                    | Description                                        | Default                            
------------------------------|----------------------------------------------------|------------------------------------
 `nginx.image`                | Image to use for nginx                             | `nginx:1.23`                       
 `nginx.max_conns`            | Number of maximum connections to the nginx workers | `100`                              
 `nginx.assets.location`      | Mount point of the assets                          | `/opt/invenio/var/instance/static` 
 `nginx.client_max_body_size` | Max size of the request body                       | `50G`                              

### Web nodes

 Parameter                                     | Description                                                               | Default                            
-----------------------------------------------|---------------------------------------------------------------------------|------------------------------------
 `web.image`                                   | Image to use for the invenio web pods                                     | `your/invenio-image`               
 `web.imagePullSecret`                         | Secrets to use to pull the invenio web pods                               | `""`                               
 `web.replicas`                                | Number of replicas for the invenio web pods                               | `6`                                
 `web.uwsgi.processes`                         | Number of uwsgi process for the web pods                                  | `6`                                
 `web.uwsgi.threads`                           | Number of uwsgi threads for the web pods                                  | `4`                                
 `web.autoscaler.enabled`                      | Should the Horizontal Pod Autoscaler (HPA) be enabled for the web pods    | `false`                            
 `web.autoscaler.scaler_cpu_utilization`       | CPU utilization threshold for the web HPA                                 | `65`                               
 `web.autoscaler.max_web_replicas`             | Max number of replicas for the web HPA                                    | `10`                               
 `web.autoscaler.min_web_replicas`             | Min number of replicas for the web HPA                                    | `2`                                
 `web.assets.location`                         | Location of the assets                                                    | `/opt/invenio/var/instance/static` 
 `web.containers.run_before_app`               | Additional command for container start to run before the application      | `""`                               
 `web.extra_volumeMounts`                      | List of objects describing additional volume mounts for the web container | `""`                               
 `web.extra_volumeMounts.<0>.name`             | Volume name                                                               | `""`                               
 `web.extra_volumeMounts.<0>.mountPath`        | Volume mount path                                                         | `""`                               
 `web.extra_volumeMounts.<0>.subPath`          | Volume subpath                                                            | `""`                               
 `web.extra_volumes`                           | List of objects describing additional volumes for the web container       | `""`                               
 `web.extra_volumes.<0>.name`                  | Volume name                                                               | `""`                               
 `web.extra_volumes.<0>.configMap.name`        | Config map name from which the volume will be sourced                     | `""`                               
 `web.extra_volumes.<0>.configMap.defaultMode` | Default mode for the access to the config map file                        | `""`                               

### Worker nodes

 Parameter                                     | Description                                                               | Default                    
-----------------------------------------------|---------------------------------------------------------------------------|----------------------------
 `worker.enabled`                              | Whether to enable the invenio workers                                     | `true`                     
 `worker.image`                                | Image to use for the invenio worker pods                                  | `your/invenio-image`       
 `worker.imagePullSecret`                      | Secrets to use to pull the invenio worker pods                            | `""`                       
 `worker.app`                                  | App used by the celery command                                            | `invenio_app.celery`       
 `worker.concurrency`                          | Number of concurrent celery workers per pod                               | `2`                        
 `worker.log_level`                            | Logging level in the invenio worker                                       | `INFO`                     
 `worker.replicas`                             | Number of replicas for the invenio worker pods                            | `2`                        
 `worker.run_mount_path`                       | `run` folder path                                                         | `/var/run`                 
 `worker.celery_pidfile`                       | Celery beat PID file                                                      | `/var/run/celerybeat.pid`  
 `worker.celery_schedule`                      | Celery schedule folder                                                    | `/var/run/celery-schedule` 
 `worker.containers.run_before_app`            | Additional command for container start to run before the application      | `""`                       
 `worker.extra_volumeMounts`                      | List of objects describing additional volume mounts for the web container | `""`                       
 `worker.extra_volumeMounts.<0>.name`             | Volume name                                                               | `""`                       
 `worker.extra_volumeMounts.<0>.mountPath`        | Volume mount path                                                         | `""`                       
 `worker.extra_volumeMounts.<0>.subPath`          | Volume subpath                                                            | `""`                       
 `worker.extra_volumes`                           | List of objects describing additional volumes for the web container       | `""`                       
 `worker.extra_volumes.<0>.name`                  | Volume name                                                               | `""`                       
 `worker.extra_volumes.<0>.configMap.name`        | Config map name from which the volume will be sourced                     | `""`                       
 `worker.extra_volumes.<0>.configMap.defaultMode` | Default mode for the access to the config map file                        | `""`                       

### Redis

 Parameter       | Description                                | Default   
-----------------|--------------------------------------------|-----------
 `redis.enabled` | Whether to enable redis within the cluster | `true`    
 `redis.image`   | Image to use for Redis                     | `redis:7` 
 `redis.host`    | Name of Redis host if `enabled` is `false` | `""`      

### RabbitMQ

 Parameter                    | Description                                           | Default                             
------------------------------|-------------------------------------------------------|-------------------------------------
 `rabbitmq.enabled`           | Whether to enable RabbitMQ within the cluster         | `true`                              
 `rabbitmq.image`             | Image to use for RabbitMQ                             | `rabbitmq:3-management`             
 `rabbitmq.existing_secret`   | Whether to use an existing secret or create a new one | `false`                             
 `rabbitmq.secret_name`       | Name of the secret to use or create                   | `mq-secrets`                        
 `rabbitmq.default_password`  | The RabbitMQ password                                 | `mq_password`                       
 `rabbitmq.celery_broker_uri` | The celery broker URL                                 | `amqp://guest:mq_password@mq:5672/` 

### PostgreSQL

 Parameter                      | Description                                           | Default                                                     
--------------------------------|-------------------------------------------------------|-------------------------------------------------------------
 `postgresql.enabled`           | Whether to enable postgresql within the cluster       | `true`                                                      
 `postgresql.existing_secret`   | Whether to use an existing secret or create a new one | `false`                                                     
 `postgresql.secret_name`       | Name of the secret to use or create                   | `db-secrets`                                                
 `postgresql.user`              | The postgresql user                                   | `invenio`                                                   
 `postgresql.password`          | The postgresql password                               | `db_password`                                               
 `postgresql.host`              | The postgresql host name                              | `db`                                                        
 `postgresql.port`              | The postgresql port                                   | `5432`                                                      
 `postgresql.database`          | The postgresql database name                          | `invenio`                                                   
 `postgresql.sqlalchemy_db_uri` | The postgresql DB URI                                 | `postgresql+psycopg2://invenio:db_password@db:5432/invenio` 

### Search

 Parameter                | Description                                           | Default            
--------------------------|-------------------------------------------------------|--------------------
 `search.enabled`         | Whether to enable the search cluster                  | `true`             
 `search.existing_secret` | Whether to use an existing secret or create a new one | `false`            
 `search.secret_name`     | Name of the secret to use or create                   | `es-secrets`       
 `search.invenio_hosts`   | The search hosts as used by invenio                   | `[{'host': 'es'}]` 
 `search.user`            | [Unimplemented] The search username                   | `username`         
 `search.password`        | [Unimplemented] The search password                   | `password`         

### Logstash

 Parameter                 | Description                                                                                      | Default                     
---------------------------|--------------------------------------------------------------------------------------------------|-----------------------------
 `logstash.enabled`        | Whether to enable Logstash within the cluster                                                    | `false`                     
 `logstash.filebeat_image` | The Filebeat image Logstash uses. It is recommended to use the one generated via the ImageStream | `filebeat_image_to_be_used` 
 `logstash.environment`    | The environment Logstash uses                                                                    | `qa`                        

## Secret management

It is recommended to configure the following variables. It can be done in the
`values-overrides.yaml` file.

```yaml

invenio:
    init: true  # initiates db, index, and admin roles
    demo_data: true  # for a demo set of records
    default_users: # for creating users on install
        "user@example.com": "password"
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

It's however **strongly advised** to override them either through a value file
or through the `--set` flag, especially if running anything else than a
private test environment. If using OpenShift, you can use
[Secrets](README-OpenShift.md/#secret-management).

You can see an example of the `--set` option. Multiple values and/or `--set`
flags can be used in the same command.

```bash
DB_PASSWORD=$(openssl rand -hex 8)
helm install -f safe-values.yaml \
  --set search.password=$SEARCH_PASSWORD \
  --set postgresql.password=$DB_PASSWORD \
  invenio ./invenio-k8s --namespace invenio
```

## Deploy your instance

To deploy your instance you have to options, directly from GitHub or from your local
clone.

### Adding a helm repository

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

### Cloning the GitHub repository

First, clone the GitHub repository and change directory:

```bash
git clone https://github.com/inveniosoftware/helm-invenio.git
cd helm-invenio/
```

If using kubernetes, you might need to add `--namespace invenio` to the
install command.

Then proceed to the installation

```bash
$ helm install [-f values-overrides.yaml] invenio ./invenio
# NAME: invenio
# LAST DEPLOYED: Mon Mar  9 16:25:15 2020
# NAMESPACE: default
# STATUS: deployed
# REVISION: 1
# TEST SUITE: None
# NOTES:Invenio is ready to rock :rocket:
```

If for some reason you need to update parameters you can simply edit them in
the `values-overrides.yaml` file and use the `upgrade` command:

```bash
$ helm upgrade --atomic -f values-overrides.yaml invenio ./invenio
# Release "invenio" has been upgraded. Happy Helming!
# NAME: invenio
# LAST DEPLOYED: Tue Dec  7 15:29:08 2021
# NAMESPACE: default
# STATUS: deployed
# REVISION: 2
# TEST SUITE: None
# NOTES:
# Invenio is ready to rock 🚀
```
