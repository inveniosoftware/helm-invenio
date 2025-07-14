# Invenio Helm Chart

This chart bootstraps an [Invenio RMD](https://inveniordm.docs.cern.ch/) deployment on a
[Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package
manager.

> [!NOTE]
> This chart works out of the box with the latest released version of Invenio RDM.
> For older versions there might be extra configuration settings needed. Check
> [Version specific configurations](#version-specific-configurations) section for more
> information on supported versions and their specific configuration.

## Pre-requisites

- Helm 3.8.0+
- Kubernetes 1.23+

## Installing the Chart

To install the chart first you need to add the repository:
```sh
helm repo add invenio https://inveniosoftware.github.io/helm-invenio
helm repo update
```

### Basic/minimal configuration

> [!WARNING]
> Please note that this configuration is not meant to be used in production.
> This configuration should be adapted and hardened depending on your infrastructure and
> constraints.

```yaml
invenio:
  hostname: "my-site.local"

# Slim down for testing
web:
  replicas: 1

worker:
  replicas: 1

redis:
  replica:
    replicaCount: 1

opensearch:
  master:
    replicaCount: 1
  ingest:
    enabled: false
  data:
    replicaCount: 1
  coordinating:
    replicaCount: 0

postgresql:
  auth:
    password: should-use-secrets

rabbitmq:
  enabled: true
  auth:
    password: should-use-secrets

```
### Cleanup

After uninstalling the chart there are a couple of resources that stay behind.
```sh
helm uninstall invenio
kubectl delete secret flower-secrets
kubectl delete secret invenio
```
After deleting the `invenio` secret you won't be able to access any of the encrypted data, it contains keys and salts used during encryption.

## Configuration and installation details

## Version specific configurations

### v12

#### nginx extra configuration to serve `robots.txt`

v13 added a templated `robots.txt` file to served all the dynamically generated sitemap
index files. To add back `robots.txt` static file serving include this in your values file:

```yaml
nginx:
  extraServerConfig: |
    location /robots.txt {
      alias {{ .Values.nginx.assets.location }}/robots.txt;
      autoindex off;
    }
```

## Parameters

### Global parameters

| Name               | Description                                    | Value           |
| ------------------ | ---------------------------------------------- | --------------- |
| `global.timezone`  | Timezone                                       | `Europe/Zurich` |
| `nameOverride`     | String to partially override common.names.name | `""`            |
| `fullnameOverride` | String to fully override common.names.fullname | `""`            |

### Invenio common parameters

| Name                                      | Description                                                                                                                      | Value                             |
| ----------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | --------------------------------- |
| `image.registry`                          | Invenio image registry                                                                                                           | `ghcr.io/inveniosoftware`         |
| `image.repository`                        | Invenio image repository                                                                                                         | `demo-inveniordm/demo-inveniordm` |
| `image.tag`                               | Invenio image tag (immutable tags are recommended). Defaults to .Chart.appVersion                                                | `""`                              |
| `image.digest`                            | Invenio image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                          | `""`                              |
| `image.pullPolicy`                        | Invenio image pull policy                                                                                                        | `IfNotPresent`                    |
| `image.pullSecrets`                       | Invenio image pull secrets                                                                                                       | `[]`                              |
| `ingress.enabled`                         | Enable ingress record generation for Invenio.                                                                                    | `false`                           |
| `ingress.class`                           | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                              |
| `ingress.annotations`                     | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                              |
| `ingress.tlsSecretNameOverride`           | Custom TLS secret name.                                                                                                          | `""`                              |
| `route.annotations`                       | Annotations to be added to the Route                                                                                             | `{}`                              |
| `invenio.hostname`                        | Invenio hostname (templated) used in configuration varibales like APP_ALLOWED_HOSTS, SITE_HOSTNAME or SITE_URL                   | `""`                              |
| `invenio.secret_key`                      | DEPRECATED: this is automatically generated now, or set by custom secret using invenio.existingSecret                            | `""`                              |
| `invenio.security_login_salt`             | DEPRECATED: this is automatically generated now, or set by custom secret using invenio.existingSecret                            | `""`                              |
| `invenio.csrf_secret_salt`                | DEPRECATED: this is automatically generated now, or set by custom secret using invenio.existingSecret                            | `""`                              |
| `invenio.existing_secret`                 | DEPRECATED: this is automatically generated now, or set by custom secret using invenio.existingSecret                            | `false`                           |
| `invenio.existingSecret`                  | General existing secret name for, at least, secret key and salts                                                                 | `""`                              |
| `invenio.init`                            |                                                                                                                                  | `false`                           |
| `invenio.default_users`                   |                                                                                                                                  | `[]`                              |
| `invenio.demo_data`                       |                                                                                                                                  | `false`                           |
| `invenio.sentry.enabled`                  | Enable Sentry.io integration                                                                                                     | `false`                           |
| `invenio.sentry.dsn`                      | Sentry DSN, required unless existingSecret is provided                                                                           | `""`                              |
| `invenio.sentry.secret_name`              | DEPRECATED: invenio.sentry.existingSecret instead                                                                                | `""`                              |
| `invenio.sentry.existing_secret`          | DEPRECATED: invenio.sentry.existingSecret instead                                                                                | `false`                           |
| `invenio.sentry.existingSecret`           | Existing secret name for sentry's dsn                                                                                            | `""`                              |
| `invenio.sentry.secretKeys.dsnKey`        | Name of key in existing secret to use for dns.                                                                                   | `SENTRY_DSN`                      |
| `invenio.datacite.enabled`                | Enable DataCite provider                                                                                                         | `false`                           |
| `invenio.datacite.username`               | Datacite username                                                                                                                | `""`                              |
| `invenio.datacite.password`               | Datacite password                                                                                                                | `""`                              |
| `invenio.datacite.existingSecret`         | Existing secret name for datacite username and password.                                                                         | `datacite-secrets`                |
| `invenio.datacite.secretKeys.usernameKey` | Name of key in existing secret to use for username. Only used when `invenio.datacite.existingSecret` is set.                     | `DATACITE_USERNAME`               |
| `invenio.datacite.secretKeys.passwordKey` | Name of key in existing secret to use for password. Only used when `invenio.datacite.existingSecret` is set.                     | `DATACITE_PASSWORD`               |
| `invenio.datacite.prefix`                 | DataCite DOI prefix, it will translate into DATACITE_PREFIX.                                                                     | `""`                              |
| `invenio.datacite.testMode`               | DataCite test mode enabled, it will trasnlate into DATACITE_TEST_MODE.                                                           | `""`                              |
| `invenio.datacite.format`                 | A string used for formatting the DOI, it will translate into DATACITE_FORMAT.                                                    | `""`                              |
| `invenio.datacite.dataCenterSymbol`       | DataCite data center symbol, it will translate into DATACITE_DATACENTER_SYMBOL.                                                  | `""`                              |
| `invenio.datacite.existing_secret`        | DEPRECATED: use invenio.datacite.existingSecret instead                                                                          | `false`                           |
| `invenio.datacite.secret_name`            | DEPRECATED: use invenio.datacite.existingSecret instead                                                                          | `""`                              |
| `invenio.remote_apps.enabled`             | TODO:                                                                                                                            | `false`                           |
| `invenio.remote_apps.existing_secret`     | TODO:                                                                                                                            | `false`                           |
| `invenio.remote_apps.secret_name`         | TODO:                                                                                                                            | `remote-apps-secrets`             |
| `invenio.remote_apps.credentials`         | TODO:                                                                                                                            | `{}`                              |
| `invenio.extra_config`                    | DEPRECATED: invenio.extraConfig instead                                                                                          | `{}`                              |
| `invenio.extraConfig`                     | Extra environment variables (templated) to be added to all the pods.                                                             | `{}`                              |
| `invenio.extra_env_from_secret`           | DEPRECATED: Use `invenio.extraEnvFrom` or `invenio.extraEnvVars` instead.                                                        | `[]`                              |
| `invenio.extraEnvVars`                    | Extra environment variables to be added to all the pods.                                                                         | `[]`                              |
| `invenio.uwsgiExtraConfig`                | Extra configuration variables (key: value) to be added to the uWSGI configuration file.                                          | `{}`                              |
| `invenio.extraEnvFrom`                    | Extra secretRef or configMapRef for the `envFrom` field in all Invenio containers (templated).                                   | `[]`                              |
| `invenio.vocabularies`                    | Vocabularies to be loaded as files under /app_data/vocabularies                                                                  | `{}`                              |

### nginx configuration

| Name                                             | Description                                                                         | Value                              |
| ------------------------------------------------ | ----------------------------------------------------------------------------------- | ---------------------------------- |
| `nginx.image`                                    | TODO:                                                                               | `nginx:1.24.0`                     |
| `nginx.max_conns`                                | TODO:                                                                               | `100`                              |
| `nginx.assets.location`                          | TODO:                                                                               | `/opt/invenio/var/instance/static` |
| `nginx.records.client_max_body_size`             | TODO:                                                                               | `100m`                             |
| `nginx.files.client_max_body_size`               | TODO:                                                                               | `50G`                              |
| `nginx.resources`                                | `resources` for the nginx container                                                 | `{}`                               |
| `nginx.extra_server_config`                      | DEPRECATED: Use nginx.extraServerConfig instead.                                    | `""`                               |
| `nginx.extraServerConfig`                        | Extra configuration to be added to nginx.conf under the server section (templated). | `""`                               |
| `nginx.denied_ips`                               | TODO:                                                                               | `""`                               |
| `nginx.denied_uas`                               | TODO:                                                                               | `""`                               |
| `nginx.securityContext`                          | SecurityContext for the nginx container                                             |                                    |
| `nginx.securityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                           | `false`                            |
| `nginx.securityContext.capabilities.drop`        | List of capabilities to be dropped                                                  | `["ALL"]`                          |

### Web

| Name                                                          | Description                                                                                                                                 | Value                                                                                                            |
| ------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| `web.image`                                                   | DEPRECATED: Use `.Values.image` instead!                                                                                                    | `""`                                                                                                             |
| `web.imagePullSecret`                                         | DEPRECATED: Use `.Values.image.imagePullSecrets` instead!                                                                                   | `""`                                                                                                             |
| `web.replicas`                                                | Number of web replicas to deploy                                                                                                            | `6`                                                                                                              |
| `web.terminationGracePeriodSeconds`                           | Seconds Redmine pod needs to terminate gracefully                                                                                           | `60`                                                                                                             |
| `web.uwsgi.processes`                                         | Number of uWSGI processes to run within each pod.                                                                                           | `6`                                                                                                              |
| `web.uwsgi.threads`                                           | Number of uWSGI threads to run within each process.                                                                                         | `4`                                                                                                              |
| `web.extraEnvVars`                                            | Extra environment variables to be added to the pods.                                                                                        | `[]`                                                                                                             |
| `web.autoscaler.enabled`                                      | Enable HPA                                                                                                                                  | `false`                                                                                                          |
| `web.autoscaler.scaler_cpu_utilization`                       | Target CPU utilization percentage                                                                                                           | `65`                                                                                                             |
| `web.autoscaler.max_web_replicas`                             | Maximum number of replicas                                                                                                                  | `10`                                                                                                             |
| `web.autoscaler.min_web_replicas`                             | Minimum number of replicas                                                                                                                  | `2`                                                                                                              |
| `web.readinessProbe`                                          | templated `readinessProbe` for the web container                                                                                            |                                                                                                                  |
| `web.readinessProbe.exec.command`                             | TODO:                                                                                                                                       | `["/bin/bash","-c","uwsgi_curl -X HEAD -H 'Host: {{ include \"invenio.hostname\" $ }}' $(hostname):5000 /ping"]` |
| `web.readinessProbe.failureThreshold`                         | TODO:                                                                                                                                       | `3`                                                                                                              |
| `web.readinessProbe.initialDelaySeconds`                      | TODO:                                                                                                                                       | `5`                                                                                                              |
| `web.readinessProbe.periodSeconds`                            | TODO:                                                                                                                                       | `5`                                                                                                              |
| `web.readinessProbe.successThreshold`                         | TODO:                                                                                                                                       | `1`                                                                                                              |
| `web.readinessProbe.timeoutSeconds`                           | TODO:                                                                                                                                       | `1`                                                                                                              |
| `web.startupProbe`                                            | Templated `startupProbe` for the web container                                                                                              |                                                                                                                  |
| `web.startupProbe.exec.command`                               | TODO:                                                                                                                                       | `["/bin/bash","-c","uwsgi_curl -X HEAD -H 'Host: {{ include \"invenio.hostname\" $ }}' $(hostname):5000 /ping"]` |
| `web.startupProbe.failureThreshold`                           | TODO:                                                                                                                                       | `3`                                                                                                              |
| `web.startupProbe.initialDelaySeconds`                        | TODO:                                                                                                                                       | `10`                                                                                                             |
| `web.startupProbe.periodSeconds`                              | TODO:                                                                                                                                       | `5`                                                                                                              |
| `web.startupProbe.successThreshold`                           | TODO:                                                                                                                                       | `1`                                                                                                              |
| `web.startupProbe.timeoutSeconds`                             | TODO:                                                                                                                                       | `5`                                                                                                              |
| `web.livenessProbe`                                           | templated `livenessProbe` for the web container                                                                                             | `nil`                                                                                                            |
| `web.assets.location`                                         | Location of the static assets                                                                                                               | `/opt/invenio/var/instance/static`                                                                               |
| `web.resources`                                               | `resources` for the web container                                                                                                           | `{}`                                                                                                             |
| `web.initContainers.resources`                                | `resources` for the copy-web-assets initContainer                                                                                           | `{}`                                                                                                             |
| `web.initContainers.securityContext`                          | securityContext for the initContainers in the web pod                                                                                       |                                                                                                                  |
| `web.initContainers.securityContext.allowPrivilegeEscalation` | set container's security context allowprivilegeescalation                                                                                   | `false`                                                                                                          |
| `web.initContainers.securityContext.capabilities.drop`        | list of capabilities to be dropped                                                                                                          | `["ALL"]`                                                                                                        |
| `web.annotations`                                             | Add extra (templated) annotations to the web service                                                                                        | `{}`                                                                                                             |
| `web.podLabels`                                               | Add extra labels to the Invenio webs pods                                                                                                   | `{}`                                                                                                             |
| `web.podAnnotations`                                          | Add extra annotations to the Invenio web pods                                                                                               | `{}`                                                                                                             |
| `web.nodeSelector`                                            | Node labels for web pods assignment                                                                                                         | `{}`                                                                                                             |
| `web.tolerations`                                             | Tolerations for web pods assignment                                                                                                         | `[]`                                                                                                             |
| `web.service.type`                                            | Web service type                                                                                                                            | `ClusterIP`                                                                                                      |
| `web.podSecurityContext`                                      | securityContext for the web pod                                                                                                             |                                                                                                                  |
| `web.podSecurityContext.runAsNonRoot`                         | TODO:                                                                                                                                       | `true`                                                                                                           |
| `web.podSecurityContext.runAsUser`                            | TODO:                                                                                                                                       | `1000`                                                                                                           |
| `web.podSecurityContext.runAsGroup`                           | TODO:                                                                                                                                       | `1000`                                                                                                           |
| `web.podSecurityContext.seccompProfile.type`                  | TODO:                                                                                                                                       | `RuntimeDefault`                                                                                                 |
| `web.securityContext`                                         | securityContext for the web container                                                                                                       |                                                                                                                  |
| `web.securityContext.allowPrivilegeEscalation`                | set container's security context allowprivilegeescalation # @param web.securityContext.capabilities.drop list of capabilities to be dropped | `false`                                                                                                          |
| `web.securityContext.capabilities.drop`                       | list of capabilities to be dropped                                                                                                          | `["ALL"]`                                                                                                        |
| `web.extraEnvFrom`                                            | Extra secretRef or configMapRef for the `envFrom` field in the web container (templated).                                                   | `[]`                                                                                                             |
| `web.extraVolumeMounts`                                       | Extra volumeMounts for the web container.                                                                                                   | `[]`                                                                                                             |
| `web.extraVolumes`                                            | Extra volumes for the web Pod.                                                                                                              | `[]`                                                                                                             |
| `web.deploymentSpec`                                          | Configuration for other configurable fields in the Deployment.spec.                                                                         |                                                                                                                  |
| `web.deploymentSpec.minReadySeconds`                          | See API spec for `Deployment.spec.minReadySeconds                                                                                           | `nil`                                                                                                            |
| `web.deploymentSpec.paused`                                   | See API spec for `Deployment.spec.paused                                                                                                    | `nil`                                                                                                            |
| `web.deploymentSpec.progressDeadlineSeconds`                  | See API spec for `Deployment.spec.progressDeadlineSeconds                                                                                   | `nil`                                                                                                            |
| `web.deploymentSpec.revisionHistoryLimit`                     | See API spec for `Deployment.spec.revisionHistoryLimit                                                                                      | `nil`                                                                                                            |
| `web.deploymentSpec.strategy`                                 | See API spec for `Deployment.spec.strategy                                                                                                  | `nil`                                                                                                            |
| `worker.image`                                                | DEPRECATED: Use `.Values.image` instead!                                                                                                    | `""`                                                                                                             |
| `worker.imagePullSecret`                                      | DEPRECATED: Use `.Values.image.imagePullSecrets` instead!                                                                                   | `""`                                                                                                             |
| `worker.app`                                                  | Name of the celery app to run.                                                                                                              | `invenio_app.celery`                                                                                             |
| `worker.concurrency`                                          | Number of concurrent tasks to run per worker.                                                                                               | `2`                                                                                                              |
| `worker.log_level`                                            | Celery app lof level.                                                                                                                       | `INFO`                                                                                                           |
| `worker.replicas`                                             | Number of web replicas to deploy.                                                                                                           | `2`                                                                                                              |
| `worker.run_mount_path`                                       |                                                                                                                                             | `/var/run/celery`                                                                                                |
| `worker.celery_pidfile`                                       |                                                                                                                                             | `/var/run/celery/celerybeat.pid`                                                                                 |
| `worker.celery_schedule`                                      |                                                                                                                                             | `/var/run/celery/celery-schedule`                                                                                |
| `worker.extraEnvVars`                                         | Extra environment variables to be added to the pods.                                                                                        | `[]`                                                                                                             |
| `worker.resources`                                            | `resources` for the worker container                                                                                                        | `{}`                                                                                                             |
| `worker.podSecurityContext`                                   | securityContext for the worker Pod                                                                                                          |                                                                                                                  |
| `worker.podSecurityContext.runAsNonRoot`                      | TODO:                                                                                                                                       | `true`                                                                                                           |
| `worker.podSecurityContext.runAsUser`                         | TODO:                                                                                                                                       | `1000`                                                                                                           |
| `worker.podSecurityContext.runAsGroup`                        | TODO:                                                                                                                                       | `1000`                                                                                                           |
| `worker.podSecurityContext.seccompProfile.type`               | TODO:                                                                                                                                       | `RuntimeDefault`                                                                                                 |
| `worker.securityContext`                                      | securityContext for the worker container                                                                                                    |                                                                                                                  |
| `worker.securityContext.allowPrivilegeEscalation`             | set container's security context allowprivilegeescalation # @param web.securityContext.capabilities.drop list of capabilities to be dropped | `false`                                                                                                          |
| `worker.securityContext.capabilities.drop`                    | list of capabilities to be dropped                                                                                                          | `["ALL"]`                                                                                                        |
| `worker.extraEnvFrom`                                         | Extra secretRef or configMapRef for the `envFrom` field in the worker container (templated).                                                | `[]`                                                                                                             |
| `worker.podLabels`                                            | Add extra labels to the Invenio workers pods                                                                                                | `{}`                                                                                                             |
| `worker.podAnnotations`                                       | Add extra annotations to the Invenio worker pods                                                                                            | `{}`                                                                                                             |
| `worker.nodeSelector`                                         | Node labels for worker pods assignment                                                                                                      | `{}`                                                                                                             |
| `worker.tolerations`                                          | Tolerations for worker pods assignment                                                                                                      | `[]`                                                                                                             |
| `worker.livenessProbe`                                        | templated `livenessProbe` for the worker container                                                                                          |                                                                                                                  |
| `worker.livenessProbe.exec.command`                           | TODO:                                                                                                                                       | `["/bin/bash","-c","celery -A {{ .Values.worker.app }} inspect ping -d celery@$(hostname)"]`                     |
| `worker.livenessProbe.initialDelaySeconds`                    | TODO:                                                                                                                                       | `20`                                                                                                             |
| `worker.livenessProbe.timeoutSeconds`                         | TODO:                                                                                                                                       | `30`                                                                                                             |
| `worker.readinessProbe`                                       | templated `readinessProbe` for the worker container                                                                                         | `nil`                                                                                                            |
| `worker.startupProbe`                                         | templated `startupProbe` for the worker container                                                                                           | `nil`                                                                                                            |
| `worker.deploymentSpec`                                       | Configuration for other configurable fields in the Deployment.spec.                                                                         |                                                                                                                  |
| `worker.deploymentSpec.minReadySeconds`                       | See API spec for `Deployment.spec.minReadySeconds                                                                                           | `nil`                                                                                                            |
| `worker.deploymentSpec.paused`                                | See API spec for `Deployment.spec.paused                                                                                                    | `nil`                                                                                                            |
| `worker.deploymentSpec.progressDeadlineSeconds`               | See API spec for `Deployment.spec.progressDeadlineSeconds                                                                                   | `nil`                                                                                                            |
| `worker.deploymentSpec.revisionHistoryLimit`                  | See API spec for `Deployment.spec.revisionHistoryLimit                                                                                      | `nil`                                                                                                            |
| `worker.deploymentSpec.strategy`                              | See API spec for `Deployment.spec.strategy                                                                                                  | `nil`                                                                                                            |
| `workerBeat.extraEnvVars`                                     | Extra environment variables to be added to the pods.                                                                                        | `[]`                                                                                                             |
| `workerBeat.resources`                                        | `resources` for the worker-beat container                                                                                                   | `{}`                                                                                                             |
| `workerBeat.securityContext`                                  | securityContext for the worker-beat container                                                                                               |                                                                                                                  |
| `workerBeat.securityContext.allowPrivilegeEscalation`         | set container's security context allowprivilegeescalation # @param web.securityContext.capabilities.drop list of capabilities to be dropped | `false`                                                                                                          |
| `workerBeat.securityContext.capabilities.drop`                | list of capabilities to be dropped                                                                                                          | `["ALL"]`                                                                                                        |
| `workerBeat.podSecurityContext`                               | securityContext for the worker-beat pod                                                                                                     |                                                                                                                  |
| `workerBeat.podSecurityContext.runAsNonRoot`                  | TODO:                                                                                                                                       | `true`                                                                                                           |
| `workerBeat.podSecurityContext.runAsUser`                     | TODO:                                                                                                                                       | `1000`                                                                                                           |
| `workerBeat.podSecurityContext.runAsGroup`                    | TODO:                                                                                                                                       | `1000`                                                                                                           |
| `workerBeat.podSecurityContext.seccompProfile.type`           | TODO:                                                                                                                                       | `RuntimeDefault`                                                                                                 |
| `workerBeat.extraEnvFrom`                                     | Extra secretRef or configMapRef for the `envFrom` field in the worker-beat container (templated).                                           | `[]`                                                                                                             |
| `workerBeat.podLabels`                                        | Add extra labels to the Invenio workerBeat pods                                                                                             | `{}`                                                                                                             |
| `workerBeat.podAnnotations`                                   | Add extra annotations to the Invenio workerBeat pods                                                                                        | `{}`                                                                                                             |
| `workerBeat.nodeSelector`                                     | Node labels for workerBeat pods assignment                                                                                                  | `{}`                                                                                                             |
| `workerBeat.tolerations`                                      | Tolerations for workerBeat pods assignment                                                                                                  | `[]`                                                                                                             |
| `workerBeat.livenessProbe`                                    | templated `livenessProbe` for the worker-beat container                                                                                     |                                                                                                                  |
| `workerBeat.livenessProbe.exec.command`                       | TODO:                                                                                                                                       | `["/bin/bash","-c","celery -A {{ .Values.worker.app }} inspect ping"]`                                           |
| `workerBeat.livenessProbe.initialDelaySeconds`                | TODO:                                                                                                                                       | `20`                                                                                                             |
| `workerBeat.livenessProbe.timeoutSeconds`                     | TODO:                                                                                                                                       | `30`                                                                                                             |
| `workerBeat.readinessProbe`                                   | templated `readinessProbe` for the worker-beat container                                                                                    | `nil`                                                                                                            |
| `workerBeat.startupProbe`                                     | templated `startupProbe` for the worker-beat container                                                                                      | `nil`                                                                                                            |
| `workerBeat.deploymentSpec`                                   | Configuration for other configurable fields in the Deployment.spec.                                                                         |                                                                                                                  |
| `workerBeat.deploymentSpec.minReadySeconds`                   | See API spec for `Deployment.spec.minReadySeconds                                                                                           | `nil`                                                                                                            |
| `workerBeat.deploymentSpec.paused`                            | See API spec for `Deployment.spec.paused                                                                                                    | `nil`                                                                                                            |
| `workerBeat.deploymentSpec.progressDeadlineSeconds`           | See API spec for `Deployment.spec.progressDeadlineSeconds                                                                                   | `nil`                                                                                                            |
| `workerBeat.deploymentSpec.revisionHistoryLimit`              | See API spec for `Deployment.spec.revisionHistoryLimit                                                                                      | `nil`                                                                                                            |
| `workerBeat.deploymentSpec.strategy`                          | See API spec for `Deployment.spec.strategy                                                                                                  | `nil`                                                                                                            |

### Terminal

| Name                                                               | Description                                                                                                                                      | Value            |
| ------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------- |
| `terminal.enabled`                                                 | Enable the terminal deployment.                                                                                                                  | `false`          |
| `terminal.replicas`                                                | Number of replicas. Start with 0 to avoid resource usage                                                                                         | `0`              |
| `terminal.extraEnvVars`                                            | Extra environment variables to be added to the pods.                                                                                             | `[]`             |
| `terminal.resources`                                               | `resources` for the terminal container                                                                                                           | `{}`             |
| `terminal.initContainers.resources`                                | `resources` for the copy-terminal-assets initContainer                                                                                           | `{}`             |
| `terminal.initContainers.securityContext`                          | securityContext for the initContainers in the terminal pod                                                                                       |                  |
| `terminal.initContainers.securityContext.allowPrivilegeEscalation` | set container's security context allowprivilegeescalation                                                                                        | `false`          |
| `terminal.initContainers.securityContext.capabilities.drop`        | list of capabilities to be dropped                                                                                                               | `["ALL"]`        |
| `terminal.nodeSelector`                                            | Node labels for terminal pods assignment                                                                                                         | `{}`             |
| `terminal.tolerations`                                             | Tolerations for terminal pods assignment                                                                                                         | `[]`             |
| `terminal.livenessProbe`                                           | templated `livenessProbe` for the terminal container                                                                                             | `nil`            |
| `terminal.readinessProbe`                                          | templated `readinessProbe` for the terminal container                                                                                            | `nil`            |
| `terminal.startupProbe`                                            | templated `startupProbe` for the terminal container                                                                                              | `nil`            |
| `terminal.podSecurityContext`                                      | securityContext for the terminal pod                                                                                                             |                  |
| `terminal.podSecurityContext.runAsNonRoot`                         | TODO:                                                                                                                                            | `true`           |
| `terminal.podSecurityContext.runAsUser`                            | TODO:                                                                                                                                            | `1000`           |
| `terminal.podSecurityContext.runAsGroup`                           | TODO:                                                                                                                                            | `1000`           |
| `terminal.podSecurityContext.seccompProfile.type`                  | TODO:                                                                                                                                            | `RuntimeDefault` |
| `terminal.securityContext`                                         | securityContext for the terminal container                                                                                                       |                  |
| `terminal.securityContext.allowPrivilegeEscalation`                | set container's security context allowprivilegeescalation # @param terminal.securityContext.capabilities.drop list of capabilities to be dropped | `false`          |
| `terminal.securityContext.capabilities.drop`                       | list of capabilities to be dropped                                                                                                               | `["ALL"]`        |
| `terminal.extraEnvFrom`                                            | Extra secretRef or configMapRef for the `envFrom` field in the terminal container (templated).                                                   | `[]`             |
| `terminal.extraVolumeMounts`                                       | Extra volumeMounts for the terminal container.                                                                                                   | `[]`             |
| `terminal.extraVolumes`                                            | Extra volumes for the terminal Pod.                                                                                                              | `[]`             |
| `terminal.deploymentSpec`                                          | Configuration for other configurable fields in the Deployment.spec.                                                                              |                  |
| `terminal.deploymentSpec.minReadySeconds`                          | See API spec for `Deployment.spec.minReadySeconds                                                                                                | `nil`            |
| `terminal.deploymentSpec.paused`                                   | See API spec for `Deployment.spec.paused                                                                                                         | `nil`            |
| `terminal.deploymentSpec.progressDeadlineSeconds`                  | See API spec for `Deployment.spec.progressDeadlineSeconds                                                                                        | `nil`            |
| `terminal.deploymentSpec.revisionHistoryLimit`                     | See API spec for `Deployment.spec.revisionHistoryLimit                                                                                           | `nil`            |
| `terminal.deploymentSpec.strategy`                                 | See API spec for `Deployment.spec.strategy                                                                                                       | `nil`            |
| `persistence.enabled`                                              | Enable persistence volume claim                                                                                                                  | `true`           |
| `persistence.name`                                                 | Name of the PVC                                                                                                                                  | `shared-volume`  |
| `persistence.access_mode`                                          | Persistent Volume Access Modes                                                                                                                   | `ReadWriteMany`  |
| `persistence.annotations`                                          | Additional Persistent Volume Claim annotations                                                                                                   | `{}`             |
| `persistence.size`                                                 | Size of the volume                                                                                                                               | `10G`            |
| `persistence.storage_class`                                        | Storage class of backing PVC                                                                                                                     | `""`             |
| `persistence.useExistingClaim`                                     | Use an existing PVC to use for persistence.                                                                                                      | `false`          |

### Redis configuration

| Name                            | Description                    | Value   |
| ------------------------------- | ------------------------------ | ------- |
| `redis.enabled`                 | Enable redis helm chart        | `true`  |
| `redis.auth.enabled`            | Enable password authentication | `false` |
| `redis.master.disableCommands`  |                                | `[]`    |
| `redis.replica.disableCommands` |                                | `[]`    |
| `redisExternal`                 | External redis configuration   | `{}`    |
| `redisExternal.hostname`        |                                |         |

### RabbitMQ chart configuration

| Name                                         | Description                                                    | Value  |
| -------------------------------------------- | -------------------------------------------------------------- | ------ |
| `rabbitmq.enabled`                           | Enable RabbitMQ helm chart                                     | `true` |
| `rabbitmq.auth.password`                     |                                                                | `""`   |
| `rabbitmqExternal`                           | External RabbitMQ configuration                                | `{}`   |
| `rabbitmqExternal.username`                  | RabbitMQ user                                                  |        |
| `rabbitmqExternal.password`                  | Password                                                       |        |
| `rabbitmqExternal.amqpPort`                  |                                                                |        |
| `rabbitmqExternal.managementPort`            |                                                                |        |
| `rabbitmqExternal.hostname`                  |                                                                |        |
| `rabbitmqExternal.protocol`                  |                                                                |        |
| `rabbitmqExternal.vhost`                     |                                                                |        |
| `rabbitmqExternal.existingSecret`            | Name of an existing secret resource containing the credentials |        |
| `rabbitmqExternal.existingSecretPasswordKey` | Name of an existing secret key containing the credentials      |        |

### Flower configuration

| Name                                            | Description                                                                                  | Value             |
| ----------------------------------------------- | -------------------------------------------------------------------------------------------- | ----------------- |
| `flower.enabled`                                | Enable Flower.                                                                               | `true`            |
| `flower.image`                                  |                                                                                              | `mher/flower:2.0` |
| `flower.secret_name`                            |                                                                                              | `flower-secrets`  |
| `flower.default_username`                       |                                                                                              | `flower`          |
| `flower.default_password`                       |                                                                                              | `flower_password` |
| `flower.host`                                   |                                                                                              | `""`              |
| `flower.resources`                              | `resources` for the flower-management container                                              | `{}`              |
| `flower.extraEnvFrom`                           | Extra secretRef or configMapRef for the `envFrom` field in the flower container (templated). | `[]`              |
| `flower.podSecurityContext`                     | securityContext for the flower pod                                                           |                   |
| `flower.podSecurityContext.runAsNonRoot`        | TODO:                                                                                        | `true`            |
| `flower.podSecurityContext.runAsUser`           | TODO:                                                                                        | `1000`            |
| `flower.podSecurityContext.runAsGroup`          | TODO:                                                                                        | `1000`            |
| `flower.podSecurityContext.seccompProfile.type` | TODO:                                                                                        | `RuntimeDefault`  |
| `flower.nodeSelector`                           | Node labels for flower pods assignment                                                       | `{}`              |
| `flower.tolerations`                            | Tolerations for flower pods assignment                                                       | `[]`              |
| `flower.livenessProbe`                          | templated `livenessProbe` for the flower-management container                                | `nil`             |
| `flower.readinessProbe`                         | templated `readinessProbe` for the flower-management container                               | `nil`             |
| `flower.startupProbe`                           | templated `startupProbe` for the flower-management container                                 | `nil`             |
| `flower.deploymentSpec`                         | Configuration for other configurable fields in the Deployment.spec.                          |                   |
| `flower.deploymentSpec.minReadySeconds`         | See API spec for `Deployment.spec.minReadySeconds                                            | `nil`             |
| `flower.deploymentSpec.paused`                  | See API spec for `Deployment.spec.paused                                                     | `nil`             |
| `flower.deploymentSpec.progressDeadlineSeconds` | See API spec for `Deployment.spec.progressDeadlineSeconds                                    | `nil`             |
| `flower.deploymentSpec.revisionHistoryLimit`    | See API spec for `Deployment.spec.revisionHistoryLimit                                       | `nil`             |
| `flower.deploymentSpec.strategy`                | See API spec for `Deployment.spec.strategy                                                   | `nil`             |

### PostgreSQL chart configuration

| Name                                           | Description                                                             | Value     |
| ---------------------------------------------- | ----------------------------------------------------------------------- | --------- |
| `postgresql.enabled`                           | Switch to enable or disable the PostgreSQL helm chart                   | `true`    |
| `postgresql.auth.username`                     | Name for a custom user to create                                        | `invenio` |
| `postgresql.auth.password`                     | Password for the custom user to create                                  | `""`      |
| `postgresql.auth.database`                     | Name for a custom database to create                                    | `invenio` |
| `postgresql.auth.existingSecret`               | Name os the existing secret to get the password from.                   | `""`      |
| `postgresqlExternal`                           | External PostgreSQL configuration                                       | `{}`      |
| `postgresqlExternal.host`                      | Database host                                                           |           |
| `postgresqlExternal.port`                      | Database port number                                                    |           |
| `postgresqlExternal.user`                      | Non-root username for Invenio                                           |           |
| `postgresqlExternal.password`                  | Password for the non-root username for Invenio                          |           |
| `postgresqlExternal.database`                  | Invenio instance database name                                          |           |
| `postgresqlExternal.existingSecret`            | Name of an existing secret resource containing the database credentials |           |
| `postgresqlExternal.existingSecretPasswordKey` | Name of an existing secret key containing the database credentials      |           |

### Opensearch chart configuration

| Name                                                | Description                                                                                                                                 | Value                                            |
| --------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------ |
| `opensearch.enabled`                                | Switch to enable or disable the Opensearch helm chart                                                                                       | `true`                                           |
| `externalOpensearch`                                | External Opensearch configuration                                                                                                           | `{}`                                             |
| `logstash.enabled`                                  |                                                                                                                                             | `false`                                          |
| `logstash.filebeat_image`                           |                                                                                                                                             | `docker.elastic.co/beats/filebeat-oss:8.10.2`    |
| `logstash.logstash_image`                           |                                                                                                                                             | `docker.elastic.co/logstash/logstash-oss:8.10.2` |
| `logstash.environment`                              |                                                                                                                                             | `qa`                                             |
| `logstash.securityContext`                          | securityContext for the logstash container                                                                                                  |                                                  |
| `logstash.securityContext.allowPrivilegeEscalation` | set container's security context allowprivilegeescalation # @param web.securityContext.capabilities.drop list of capabilities to be dropped | `false`                                          |
| `logstash.securityContext.capabilities.drop`        | list of capabilities to be dropped                                                                                                          | `["ALL"]`                                        |
| `kerberos.enabled`                                  |                                                                                                                                             | `false`                                          |
| `kerberos.secret_name`                              |                                                                                                                                             | `""`                                             |
| `kerberos.image`                                    |                                                                                                                                             | `""`                                             |
| `kerberos.args`                                     |                                                                                                                                             | `[]`                                             |
| `kerberos.initArgs`                                 |                                                                                                                                             | `[]`                                             |
| `kerberos.resources`                                | `resources` for the kerberos-credentials container                                                                                          | `{}`                                             |
| `kerberos.securityContext`                          | securityContext for the kerberos container                                                                                                  |                                                  |
| `kerberos.securityContext.allowPrivilegeEscalation` | set container's security context allowprivilegeescalation # @param web.securityContext.capabilities.drop list of capabilities to be dropped | `false`                                          |
| `kerberos.securityContext.capabilities.drop`        | list of capabilities to be dropped                                                                                                          | `["ALL"]`                                        |
| `kerberos.initContainers.resources`                 | `resources` for the init-kerberos-credentials initContainers                                                                                | `{}`                                             |
