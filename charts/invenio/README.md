# invenio

A helm chart for deploying Invenio RDM to Kubernetes.

![Version: 0.14.0](https://img.shields.io/badge/Version-0.14.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 12.0.10](https://img.shields.io/badge/AppVersion-12.0.10-informational?style=flat-square)

**Homepage:** <https://inveniosoftware.org/>

## Source Code

* <https://github.com/inveniosoftware/helm-invenio>
* <https://github.com/inveniosoftware/invenio-app-rdm>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| oci://registry-1.docker.io/bitnamicharts | opensearch | 1.4.0 |
| oci://registry-1.docker.io/bitnamicharts | postgresql | 14.3.3 |
| oci://registry-1.docker.io/bitnamicharts | rabbitmq | 12.9.3 |
| oci://registry-1.docker.io/bitnamicharts | redis | 18.12.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| flower.default_password | string | `"flower_password"` | Flower default password |
| flower.default_username | string | `"flower"` | Flower default username |
| flower.deployment.annotations | object | `{}` | Extra annotations for the flower Deployment |
| flower.deployment.labels | object | `{}` | Extra labels for the flower Deployment |
| flower.deployment.spec | object | `{"minReadySeconds":null,"paused":null,"progressDeadlineSeconds":null,"revisionHistoryLimit":null,"strategy":null}` | Configuration for other configurable fields in the Deployment.spec |
| flower.deployment.spec.minReadySeconds | string | `nil` | See API spec for `Deployment.spec.minReadySeconds` |
| flower.deployment.spec.paused | string | `nil` | See API spec for `Deployment.spec.paused` |
| flower.deployment.spec.progressDeadlineSeconds | string | `nil` | See API spec for `Deployment.spec.progressDeadlineSeconds` |
| flower.deployment.spec.revisionHistoryLimit | string | `nil` | See API spec for `Deployment.spec.revisionHistoryLimit` |
| flower.deployment.spec.strategy | string | `nil` | See API spec for `Deployment.spec.strategy` |
| flower.deploymentSpec | object | `{"minReadySeconds":null,"paused":null,"progressDeadlineSeconds":null,"revisionHistoryLimit":null,"strategy":null}` | DEPRECATED: Use `.Values.flower.deployment.spec` instead! |
| flower.deploymentSpec.minReadySeconds | string | `nil` | See API spec for `Deployment.spec.minReadySeconds` |
| flower.deploymentSpec.paused | string | `nil` | See API spec for `Deployment.spec.paused` |
| flower.deploymentSpec.progressDeadlineSeconds | string | `nil` | See API spec for `Deployment.spec.progressDeadlineSeconds` |
| flower.deploymentSpec.revisionHistoryLimit | string | `nil` | See API spec for `Deployment.spec.revisionHistoryLimit` |
| flower.deploymentSpec.strategy | string | `nil` | See API spec for `Deployment.spec.strategy` |
| flower.enabled | bool | `true` | Enable Flower |
| flower.extraEnvFrom | list | `[]` | Extra secretRef or configMapRef for the `envFrom` field in the flower container (templated) |
| flower.host | string | `""` | Flower host |
| flower.image | string | `"mher/flower:2.0"` | Flower image |
| flower.livenessProbe | string | `nil` | Templated `livenessProbe` for the flower container |
| flower.nodeSelector | object | `{}` | Node labels for flower pods assignment |
| flower.podAnnotations | object | `{}` | Add extra annotations to the Invenio flower pods |
| flower.podLabels | object | `{}` | Add extra labels to the Invenio flower pods |
| flower.podSecurityContext | object | `{"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000,"seccompProfile":{"type":"RuntimeDefault"}}` | SecurityContext for the flower pod |
| flower.readinessProbe | string | `nil` | Templated `readinessProbe` for the flower container |
| flower.resources | object | `{}` | Resources for the flower container |
| flower.secret_name | string | `"flower-secrets"` | Flower secret name |
| flower.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]}}` | SecurityContext for the flower container |
| flower.startupProbe | string | `nil` | Templated `startupProbe` for the flower container |
| flower.tolerations | list | `[]` | Tolerations for flower pods assignment |
| fullnameOverride | string | `""` | String to fully override common.names.fullname |
| global.timezone | string | `"Europe/Zurich"` | Timezone |
| image.digest | string | `""` | Invenio image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag |
| image.pullPolicy | string | `"IfNotPresent"` | Invenio image pull policy |
| image.pullSecrets | list | `[]` | Invenio image pull secrets |
| image.registry | string | `"ghcr.io/inveniosoftware"` | Invenio image registry |
| image.repository | string | `"demo-inveniordm/demo-inveniordm"` | Invenio image repository |
| image.tag | string | `""` | Invenio image tag (immutable tags are recommended). Defaults to .Chart.appVersion |
| ingress.annotations | object | `{}` | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. |
| ingress.class | string | `""` | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+) |
| ingress.enabled | bool | `false` | Enable ingress record generation for Invenio. |
| ingress.tlsSecretNameOverride | string | `""` | Custom TLS secret name. |
| invenio.csrf_secret_salt | string | `""` | DEPRECATED: this is automatically generated now, or set by custom secret using invenio.existingSecret |
| invenio.datacite.dataCenterSymbol | string | `""` | DataCite data center symbol, it will translate into DATACITE_DATACENTER_SYMBOL |
| invenio.datacite.enabled | bool | `false` | Enable DataCite provider |
| invenio.datacite.existingSecret | string | `"datacite-secrets"` | Existing secret name for datacite username and password |
| invenio.datacite.existing_secret | bool | `false` | DEPRECATED: use invenio.datacite.existingSecret instead |
| invenio.datacite.format | string | `""` | A string used for formatting the DOI, it will translate into DATACITE_FORMAT |
| invenio.datacite.password | string | `""` | Datacite password |
| invenio.datacite.prefix | string | `""` | DataCite DOI prefix, it will translate into DATACITE_PREFIX |
| invenio.datacite.secretKeys | object | `{"passwordKey":"DATACITE_PASSWORD","usernameKey":"DATACITE_USERNAME"}` | Secret keys configuration for datacite |
| invenio.datacite.secretKeys.passwordKey | string | `"DATACITE_PASSWORD"` | Name of key in existing secret to use for password. Only used when `invenio.datacite.existingSecret` is set. |
| invenio.datacite.secretKeys.usernameKey | string | `"DATACITE_USERNAME"` | Name of key in existing secret to use for username. Only used when `invenio.datacite.existingSecret` is set. |
| invenio.datacite.secret_name | string | `""` | DEPRECATED: use invenio.datacite.existingSecret instead |
| invenio.datacite.testMode | string | `""` | DataCite test mode enabled, it will translate into DATACITE_TEST_MODE |
| invenio.datacite.username | string | `""` | Datacite username |
| invenio.default_users | list | `[]` | Default users to create. Requires invenio.init=true |
| invenio.demo_data | bool | `false` | Load demo data. Requires invenio.init=true and default_users to be set |
| invenio.existingSecret | string | `""` | General existing secret name for, at least, secret key and salts |
| invenio.existing_secret | bool | `false` | DEPRECATED: this is automatically generated now, or set by custom secret using invenio.existingSecret |
| invenio.extraConfig | object | `{}` | Extra environment variables (templated) to be added to all the pods |
| invenio.extraEnvFrom | list | `[]` | Extra secretRef or configMapRef for the `envFrom` field in all Invenio containers (templated) |
| invenio.extraEnvVars | list | `[]` | Extra environment variables to be added to all the pods |
| invenio.extraVolumeMounts | list | `[]` | Extra volumeMounts for all Invenio containers |
| invenio.extraVolumes | list | `[]` | Extra volumes for all Invenio pods |
| invenio.extra_config | object | `{}` | DEPRECATED: use invenio.extraConfig instead |
| invenio.extra_env_from_secret | list | `[]` | DEPRECATED: Use `invenio.extraEnvFrom` or `invenio.extraEnvVars` instead |
| invenio.hostname | string | `""` | Invenio hostname (templated) used in configuration variables like TRUSTED_HOSTS, SITE_HOSTNAME or SITE_URL |
| invenio.init | bool | `false` | Enable initial setup (create users, load demo data) |
| invenio.remote_apps.credentials | object | `{}` | Remote apps credentials |
| invenio.remote_apps.enabled | bool | `false` | Enable remote apps integration |
| invenio.remote_apps.existing_secret | bool | `false` | Use an existing secret for remote apps credentials |
| invenio.remote_apps.secret_name | string | `"remote-apps-secrets"` | Name of the existing secret for remote apps |
| invenio.secret_key | string | `""` | DEPRECATED: this is automatically generated now, or set by custom secret using invenio.existingSecret |
| invenio.security_login_salt | string | `""` | DEPRECATED: this is automatically generated now, or set by custom secret using invenio.existingSecret |
| invenio.sentry.dsn | string | `""` | Sentry DSN, required unless existingSecret is provided |
| invenio.sentry.enabled | bool | `false` | Enable Sentry.io integration |
| invenio.sentry.existingSecret | string | `""` | Existing secret name for sentry's dsn |
| invenio.sentry.existing_secret | bool | `false` | DEPRECATED: use invenio.sentry.existingSecret instead |
| invenio.sentry.secretKeys | object | `{"dsnKey":"SENTRY_DSN"}` | Secret keys configuration for sentry |
| invenio.sentry.secretKeys.dsnKey | string | `"SENTRY_DSN"` | Name of key in existing secret to use for dsn |
| invenio.sentry.secret_name | string | `""` | DEPRECATED: use invenio.sentry.existingSecret instead |
| invenio.uwsgiExtraConfig | object | `{}` | Extra configuration variables (key: value) to be added to the uWSGI configuration file |
| invenio.vocabularies | object | `{}` | Vocabularies to be loaded as files under /app_data/vocabularies |
| kerberos.args | list | `[]` | Kerberos sidecar args |
| kerberos.enabled | bool | `false` | Enable Kerberos integration |
| kerberos.image | string | `""` | Kerberos sidecar image |
| kerberos.initArgs | list | `[]` | Kerberos init container args |
| kerberos.initContainers.resources | object | `{}` | Resources for the init-kerberos-credentials initContainers |
| kerberos.resources | object | `{}` | Resources for the kerberos-credentials container |
| kerberos.secret_name | string | `""` | Kerberos secret name |
| kerberos.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]}}` | SecurityContext for the kerberos container |
| nameOverride | string | `""` | String to partially override common.names.name |
| nginx.assets | object | `{"location":"/opt/invenio/var/instance/static"}` | Assets configuration |
| nginx.assets.location | string | `"/opt/invenio/var/instance/static"` | Location of the static assets |
| nginx.denied_ips | string | `""` | Denied IP addresses |
| nginx.denied_uas | string | `""` | Denied user agents |
| nginx.extraServerConfig | string | `""` | Extra configuration to be added to nginx.conf under the server section (templated) |
| nginx.extra_server_config | string | `""` | DEPRECATED: Use nginx.extraServerConfig instead |
| nginx.files | object | `{"client_max_body_size":"50G"}` | Files configuration |
| nginx.files.client_max_body_size | string | `"50G"` | Client max body size for files |
| nginx.image | string | `"nginx:1.31.1"` | Nginx image |
| nginx.max_conns | int | `100` | Maximum number of connections |
| nginx.records | object | `{"client_max_body_size":"100m"}` | Records configuration |
| nginx.records.client_max_body_size | string | `"100m"` | Client max body size for records |
| nginx.resources | object | `{}` | Resources for the nginx container |
| nginx.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]}}` | SecurityContext for the nginx container |
| opensearch.dashboards.image.repository | string | `"bitnamilegacy/opensearch-dashboards"` | Sets bitnamilegacy by default |
| opensearch.enabled | bool | `true` | Switch to enable or disable the Opensearch helm chart |
| opensearch.image.repository | string | `"bitnamilegacy/opensearch"` | Sets bitnamilegacy by default |
| opensearch.sysctlImage.repository | string | `"bitnamilegacy/os-shell"` | Sets bitnamilegacy by default |
| opensearchExternal | object | `{}` | External Opensearch configuration |
| persistence.access_mode | string | `"ReadWriteMany"` | Persistent Volume Access Modes |
| persistence.annotations | object | `{}` | Additional Persistent Volume Claim annotations |
| persistence.enabled | bool | `true` | Enable persistence volume claim |
| persistence.name | string | `"shared-volume"` | Name of the PVC |
| persistence.size | string | `"10G"` | Size of the volume |
| persistence.storage_class | string | `""` | Storage class of backing PVC |
| persistence.useExistingClaim | bool | `false` | Use an existing PVC to use for persistence |
| persistence.useSubPath | bool | `true` | Enable or disable usage of subPath for PVC mounts |
| postgresql.auth.database | string | `"invenio"` | Name for a custom database to create |
| postgresql.auth.existingSecret | string | `""` | Name of the existing secret to get the password from |
| postgresql.auth.password | string | `""` | Password for the custom user to create |
| postgresql.auth.username | string | `"invenio"` | Name for a custom user to create |
| postgresql.enabled | bool | `true` | Switch to enable or disable the PostgreSQL helm chart |
| postgresql.image.repository | string | `"bitnamilegacy/postgresql"` | Sets bitnamilegacy by default |
| postgresql.snapshots.image.repository | string | `"bitnamilegacy/os-shell"` | Sets bitnamilegacy by default |
| postgresqlExternal | object | `{}` | External PostgreSQL configuration |
| rabbitmq.auth.password | string | `""` | RabbitMQ password |
| rabbitmq.enabled | bool | `true` | Enable RabbitMQ helm chart |
| rabbitmq.image.repository | string | `"bitnamilegacy/rabbitmq"` | Sets bitnamilegacy by default |
| rabbitmqExternal | object | `{}` | External RabbitMQ configuration |
| redis.auth.enabled | bool | `false` | Enable password authentication |
| redis.enabled | bool | `true` | Enable redis helm chart |
| redis.image.repository | string | `"bitnamilegacy/redis"` | Sets bitnamilegacy by default |
| redis.master.disableCommands | list | `[]` | Disable commands |
| redis.replica.disableCommands | list | `[]` | Disable commands |
| redisExternal | object | `{}` | External redis configuration |
| route.annotations | object | `{}` | Annotations to be added to the Route |
| terminal.deployment.annotations | object | `{}` | Extra annotations for the terminal Deployment |
| terminal.deployment.labels | object | `{}` | Extra labels for the terminal Deployment |
| terminal.deployment.spec | object | `{"minReadySeconds":null,"paused":null,"progressDeadlineSeconds":null,"revisionHistoryLimit":null,"strategy":null}` | Configuration for other configurable fields in the Deployment.spec |
| terminal.deployment.spec.minReadySeconds | string | `nil` | See API spec for `Deployment.spec.minReadySeconds` |
| terminal.deployment.spec.paused | string | `nil` | See API spec for `Deployment.spec.paused` |
| terminal.deployment.spec.progressDeadlineSeconds | string | `nil` | See API spec for `Deployment.spec.progressDeadlineSeconds` |
| terminal.deployment.spec.revisionHistoryLimit | string | `nil` | See API spec for `Deployment.spec.revisionHistoryLimit` |
| terminal.deployment.spec.strategy | string | `nil` | See API spec for `Deployment.spec.strategy` |
| terminal.deploymentSpec | object | `{"minReadySeconds":null,"paused":null,"progressDeadlineSeconds":null,"revisionHistoryLimit":null,"strategy":null}` | DEPRECATED: Use `.Values.terminal.deployment.spec` instead! |
| terminal.deploymentSpec.minReadySeconds | string | `nil` | See API spec for `Deployment.spec.minReadySeconds` |
| terminal.deploymentSpec.paused | string | `nil` | See API spec for `Deployment.spec.paused` |
| terminal.deploymentSpec.progressDeadlineSeconds | string | `nil` | See API spec for `Deployment.spec.progressDeadlineSeconds` |
| terminal.deploymentSpec.revisionHistoryLimit | string | `nil` | See API spec for `Deployment.spec.revisionHistoryLimit` |
| terminal.deploymentSpec.strategy | string | `nil` | See API spec for `Deployment.spec.strategy` |
| terminal.enabled | bool | `false` | Enable the terminal deployment |
| terminal.extraEnvFrom | list | `[]` | Extra secretRef or configMapRef for the `envFrom` field in the terminal container (templated) |
| terminal.extraEnvVars | list | `[]` | Extra environment variables to be added to the terminal pods |
| terminal.extraVolumeMounts | list | `[]` | Extra volumeMounts for the terminal container |
| terminal.extraVolumes | list | `[]` | Extra volumes for the terminal Pod |
| terminal.initContainers.resources | object | `{}` | Resources for the copy-terminal-assets initContainer |
| terminal.initContainers.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]}}` | SecurityContext for the initContainers in the terminal pod |
| terminal.livenessProbe | string | `nil` | Templated `livenessProbe` for the terminal container |
| terminal.nodeSelector | object | `{}` | Node labels for terminal pods assignment |
| terminal.podSecurityContext | object | `{"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000,"seccompProfile":{"type":"RuntimeDefault"}}` | SecurityContext for the terminal pod |
| terminal.readinessProbe | string | `nil` | Templated `readinessProbe` for the terminal container |
| terminal.replicas | int | `0` | Number of replicas. Start with 0 to avoid resource usage |
| terminal.resources | object | `{}` | Resources for the terminal container |
| terminal.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]}}` | SecurityContext for the terminal container |
| terminal.startupProbe | string | `nil` | Templated `startupProbe` for the terminal container |
| terminal.tolerations | list | `[]` | Tolerations for terminal pods assignment |
| web.affinity | object | `{}` | Affinity rules for web pods assignment |
| web.annotations | object | `{}` | DEPRECATED: Use `.Values.web.service.annotations` instead! |
| web.assets | object | `{"location":"/opt/invenio/var/instance/static"}` | Assets configuration |
| web.assets.location | string | `"/opt/invenio/var/instance/static"` | Location of the static assets |
| web.autoscaler.enabled | bool | `false` | Enable HPA |
| web.autoscaler.max_web_replicas | int | `10` | Maximum number of replicas |
| web.autoscaler.min_web_replicas | int | `2` | Minimum number of replicas |
| web.autoscaler.scaler_cpu_utilization | int | `65` | Target CPU utilization percentage |
| web.deployment.annotations | object | `{}` | Extra annotations for the web Deployment |
| web.deployment.labels | object | `{}` | Extra labels for the web Deployment |
| web.deployment.spec | object | `{"minReadySeconds":null,"paused":null,"progressDeadlineSeconds":null,"revisionHistoryLimit":null,"strategy":null}` | Configuration for other configurable fields in the Deployment.spec |
| web.deployment.spec.minReadySeconds | string | `nil` | See API spec for `Deployment.spec.minReadySeconds` |
| web.deployment.spec.paused | string | `nil` | See API spec for `Deployment.spec.paused` |
| web.deployment.spec.progressDeadlineSeconds | string | `nil` | See API spec for `Deployment.spec.progressDeadlineSeconds` |
| web.deployment.spec.revisionHistoryLimit | string | `nil` | See API spec for `Deployment.spec.revisionHistoryLimit` |
| web.deployment.spec.strategy | string | `nil` | See API spec for `Deployment.spec.strategy` |
| web.deploymentSpec | object | `{"minReadySeconds":null,"paused":null,"progressDeadlineSeconds":null,"revisionHistoryLimit":null,"strategy":null}` | DEPRECATED: Use `.Values.web.deployment.spec` instead! |
| web.deploymentSpec.minReadySeconds | string | `nil` | See API spec for `Deployment.spec.minReadySeconds` |
| web.deploymentSpec.paused | string | `nil` | See API spec for `Deployment.spec.paused` |
| web.deploymentSpec.progressDeadlineSeconds | string | `nil` | See API spec for `Deployment.spec.progressDeadlineSeconds` |
| web.deploymentSpec.revisionHistoryLimit | string | `nil` | See API spec for `Deployment.spec.revisionHistoryLimit` |
| web.deploymentSpec.strategy | string | `nil` | See API spec for `Deployment.spec.strategy` |
| web.extraEnvFrom | list | `[]` | Extra secretRef or configMapRef for the `envFrom` field in the web container (templated) |
| web.extraEnvVars | list | `[]` | Extra environment variables to be added to the web pods |
| web.extraVolumeMounts | list | `[]` | Extra volumeMounts for the web container |
| web.extraVolumes | list | `[]` | Extra volumes for the web Pod |
| web.image | string | `""` | DEPRECATED: Use `.Values.image` instead! |
| web.imagePullSecret | string | `""` | DEPRECATED: Use `.Values.image.imagePullSecrets` instead! |
| web.initContainers.resources | object | `{}` | Resources for the copy-web-assets initContainer |
| web.initContainers.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]}}` | SecurityContext for the initContainers in the web pod |
| web.livenessProbe | string | `nil` | Templated `livenessProbe` for the web container |
| web.nodeSelector | object | `{}` | Node labels for web pods assignment |
| web.podAnnotations | object | `{}` | Add extra annotations to the Invenio web pods |
| web.podLabels | object | `{}` | Add extra labels to the Invenio web pods |
| web.podSecurityContext | object | `{"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000,"seccompProfile":{"type":"RuntimeDefault"}}` | SecurityContext for the web pod |
| web.readinessProbe | object | `{"exec":{"command":["/bin/bash","-c","uwsgi_curl -X HEAD -H 'Host: {{ include \"invenio.hostname\" $ }}' $(hostname):5000 /ping"]},"failureThreshold":3,"initialDelaySeconds":5,"periodSeconds":5,"successThreshold":1,"timeoutSeconds":1}` | Templated `readinessProbe` for the web container |
| web.replicas | int | `6` | Number of web replicas to deploy |
| web.resources | object | `{}` | Resources for the web container |
| web.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]}}` | SecurityContext for the web container |
| web.service.annotations | object | `{}` | Add extra (templated) annotations to the web service |
| web.service.type | string | `"ClusterIP"` | Web service type |
| web.startupProbe | object | `{"exec":{"command":["/bin/bash","-c","uwsgi_curl -X HEAD -H 'Host: {{ include \"invenio.hostname\" $ }}' $(hostname):5000 /ping"]},"failureThreshold":3,"initialDelaySeconds":10,"periodSeconds":5,"successThreshold":1,"timeoutSeconds":5}` | Templated `startupProbe` for the web container |
| web.terminationGracePeriodSeconds | int | `60` | Seconds the pod needs to terminate gracefully |
| web.tolerations | list | `[]` | Tolerations for web pods assignment |
| web.uwsgi.processes | int | `6` | Number of uWSGI processes to run within each pod |
| web.uwsgi.threads | int | `4` | Number of uWSGI threads to run within each process |
| worker.affinity | object | `{}` | Affinity rules for worker pods assignment |
| worker.app | string | `"invenio_app.celery"` | Name of the celery app to run |
| worker.celery_pidfile | string | `"/var/run/celery/celerybeat.pid"` | Path to celery PID file |
| worker.celery_schedule | string | `"/var/run/celery/celery-schedule"` | Path to celery schedule file |
| worker.concurrency | int | `2` | Number of concurrent tasks to run per worker |
| worker.deployment.annotations | object | `{}` | Extra annotations for the worker Deployment |
| worker.deployment.labels | object | `{}` | Extra labels for the worker Deployment |
| worker.deployment.spec | object | `{"minReadySeconds":null,"paused":null,"progressDeadlineSeconds":null,"revisionHistoryLimit":null,"strategy":null}` | Configuration for other configurable fields in the Deployment.spec |
| worker.deployment.spec.minReadySeconds | string | `nil` | See API spec for `Deployment.spec.minReadySeconds` |
| worker.deployment.spec.paused | string | `nil` | See API spec for `Deployment.spec.paused` |
| worker.deployment.spec.progressDeadlineSeconds | string | `nil` | See API spec for `Deployment.spec.progressDeadlineSeconds` |
| worker.deployment.spec.revisionHistoryLimit | string | `nil` | See API spec for `Deployment.spec.revisionHistoryLimit` |
| worker.deployment.spec.strategy | string | `nil` | See API spec for `Deployment.spec.strategy` |
| worker.deploymentSpec | object | `{"minReadySeconds":null,"paused":null,"progressDeadlineSeconds":null,"revisionHistoryLimit":null,"strategy":null}` | DEPRECATED: Use `.Values.worker.deployment.spec` instead! |
| worker.deploymentSpec.minReadySeconds | string | `nil` | See API spec for `Deployment.spec.minReadySeconds` |
| worker.deploymentSpec.paused | string | `nil` | See API spec for `Deployment.spec.paused` |
| worker.deploymentSpec.progressDeadlineSeconds | string | `nil` | See API spec for `Deployment.spec.progressDeadlineSeconds` |
| worker.deploymentSpec.revisionHistoryLimit | string | `nil` | See API spec for `Deployment.spec.revisionHistoryLimit` |
| worker.deploymentSpec.strategy | string | `nil` | See API spec for `Deployment.spec.strategy` |
| worker.extraEnvFrom | list | `[]` | Extra secretRef or configMapRef for the `envFrom` field in the worker container (templated) |
| worker.extraEnvVars | list | `[]` | Extra environment variables to be added to the worker pods |
| worker.extraVolumeMounts | list | `[]` | Extra volumeMounts for the worker container |
| worker.extraVolumes | list | `[]` | Extra volumes for the worker Pod |
| worker.image | string | `""` | DEPRECATED: Use `.Values.image` instead! |
| worker.imagePullSecret | string | `""` | DEPRECATED: Use `.Values.image.imagePullSecrets` instead! |
| worker.livenessProbe | object | `{"exec":{"command":["/bin/bash","-c","celery -A {{ .Values.worker.app }} inspect ping -d celery@$(hostname)"]},"initialDelaySeconds":20,"timeoutSeconds":30}` | Templated `livenessProbe` for the worker container |
| worker.log_level | string | `"INFO"` | Celery app log level |
| worker.nodeSelector | object | `{}` | Node labels for worker pods assignment |
| worker.podAnnotations | object | `{}` | Add extra annotations to the Invenio worker pods |
| worker.podLabels | object | `{}` | Add extra labels to the Invenio worker pods |
| worker.podSecurityContext | object | `{"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000,"seccompProfile":{"type":"RuntimeDefault"}}` | SecurityContext for the worker Pod |
| worker.readinessProbe | string | `nil` | Templated `readinessProbe` for the worker container |
| worker.replicas | int | `2` | Number of worker replicas to deploy |
| worker.resources | object | `{}` | Resources for the worker container |
| worker.run_mount_path | string | `"/var/run/celery"` | Mount path for celery run files |
| worker.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]}}` | SecurityContext for the worker container |
| worker.startupProbe | string | `nil` | Templated `startupProbe` for the worker container |
| worker.tolerations | list | `[]` | Tolerations for worker pods assignment |
| workerBeat.affinity | object | `{}` | Affinity rules for workerBeat pods assignment |
| workerBeat.commandOverride | string | `""` | Override the worker-beat command |
| workerBeat.deployment.annotations | object | `{}` | Extra annotations for the workerBeat Deployment |
| workerBeat.deployment.labels | object | `{}` | Extra labels for the workerBeat Deployment |
| workerBeat.deployment.spec | object | `{"minReadySeconds":null,"paused":null,"progressDeadlineSeconds":null,"revisionHistoryLimit":null,"strategy":null}` | Configuration for other configurable fields in the Deployment.spec |
| workerBeat.deployment.spec.minReadySeconds | string | `nil` | See API spec for `Deployment.spec.minReadySeconds` |
| workerBeat.deployment.spec.paused | string | `nil` | See API spec for `Deployment.spec.paused` |
| workerBeat.deployment.spec.progressDeadlineSeconds | string | `nil` | See API spec for `Deployment.spec.progressDeadlineSeconds` |
| workerBeat.deployment.spec.revisionHistoryLimit | string | `nil` | See API spec for `Deployment.spec.revisionHistoryLimit` |
| workerBeat.deployment.spec.strategy | string | `nil` | See API spec for `Deployment.spec.strategy` |
| workerBeat.deploymentSpec | object | `{"minReadySeconds":null,"paused":null,"progressDeadlineSeconds":null,"revisionHistoryLimit":null,"strategy":null}` | DEPRECATED: Use `.Values.workerBeat.deployment.spec` instead! |
| workerBeat.deploymentSpec.minReadySeconds | string | `nil` | See API spec for `Deployment.spec.minReadySeconds` |
| workerBeat.deploymentSpec.paused | string | `nil` | See API spec for `Deployment.spec.paused` |
| workerBeat.deploymentSpec.progressDeadlineSeconds | string | `nil` | See API spec for `Deployment.spec.progressDeadlineSeconds` |
| workerBeat.deploymentSpec.revisionHistoryLimit | string | `nil` | See API spec for `Deployment.spec.revisionHistoryLimit` |
| workerBeat.deploymentSpec.strategy | string | `nil` | See API spec for `Deployment.spec.strategy` |
| workerBeat.extraEnvFrom | list | `[]` | Extra secretRef or configMapRef for the `envFrom` field in the worker-beat container (templated) |
| workerBeat.extraEnvVars | list | `[]` | Extra environment variables to be added to the worker-beat pods |
| workerBeat.extraVolumeMounts | list | `[]` | Extra volumeMounts for the worker-beat container |
| workerBeat.extraVolumes | list | `[]` | Extra volumes for the worker-beat Pod |
| workerBeat.livenessProbe | object | `{"exec":{"command":["/bin/bash","-c","celery -A {{ .Values.worker.app }} inspect ping"]},"initialDelaySeconds":20,"timeoutSeconds":30}` | Templated `livenessProbe` for the worker-beat container |
| workerBeat.nodeSelector | object | `{}` | Node labels for workerBeat pods assignment |
| workerBeat.podAnnotations | object | `{}` | Add extra annotations to the Invenio workerBeat pods |
| workerBeat.podLabels | object | `{}` | Add extra labels to the Invenio workerBeat pods |
| workerBeat.podSecurityContext | object | `{"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000,"seccompProfile":{"type":"RuntimeDefault"}}` | SecurityContext for the worker-beat pod |
| workerBeat.readinessProbe | string | `nil` | Templated `readinessProbe` for the worker-beat container |
| workerBeat.resources | object | `{}` | Resources for the worker-beat container |
| workerBeat.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]}}` | SecurityContext for the worker-beat container |
| workerBeat.startupProbe | string | `nil` | Templated `startupProbe` for the worker-beat container |
| workerBeat.tolerations | list | `[]` | Tolerations for workerBeat pods assignment |

