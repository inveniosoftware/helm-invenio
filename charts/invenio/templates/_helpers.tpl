###########################     Invenio hostname     ###########################
{{/*
  This template renders the hostname for Invenio.
*/}}
{{- define "invenio.hostname" -}}
  {{- required "Missing .Values.invenio.hostname" .Values.invenio.hostname }}
{{- end -}}

############################     Redis Hostname     ############################
{{/*
  This template renders the hostname for the Redis instance used.
*/}}
{{- define "invenio.redis.hostname" -}}
  {{- if .Values.redis.enabled }}
    {{- printf "%s-master" (include "common.names.fullname" .Subcharts.redis) }}
  {{- else }}
      {{- required "Missing .Values.redisExternal.hostname" .Values.redisExternal.hostname }}
  {{- end }}
{{- end -}}

#######################     Ingress TLS secret name     #######################
{{/*
  This template renders the name of the TLS secret used in
  `Ingress.spec.tls.secretName`.
*/}}
{{- define "invenio.tlsSecretName" -}}
  {{- if .Values.ingress.tlsSecretNameOverride }}
    {{- tpl .Values.ingress.tlsSecretNameOverride $ }}
  {{- else }}
    {{- include "invenio.hostname" . -}}-tls
  {{- end }}
{{- end -}}

#######################     RabbitMQ password secret     #######################
{{/*
  This template renders the name of the secret that stores the password for RabbitMQ.
*/}}
{{- define "invenio.rabbitmq.passwordSecret" -}}
  {{- if .Values.rabbitmq.enabled }}
    {{- include "rabbitmq.secretPasswordName" .Subcharts.rabbitmq }}
  {{- else }}
      {{- required "Missing .Values.rabbitmqExternal.existingPasswordSecret" .Values.rabbitmqExternal.existingPasswordSecret }}
  {{- end }}
{{- end -}}

##########################     RabbitMQ username     ##########################
{{/*
  This template renders the username for accessing RabbitMQ.
*/}}
{{- define "invenio.rabbitmq.username" -}}
  {{- if .Values.rabbitmq.enabled }}
    {{- required "Missing .Values.rabbitmq.auth.username" .Values.rabbitmq.auth.username -}}
  {{- else }}
    {{- required "Missing .Values.rabbitmqExternal.username" .Values.rabbitmqExternal.username -}}
  {{- end }}
{{- end -}}

##########################     RabbitMQ password     ##########################
{{/*
  This template renders the password for accessing RabbitMQ.
*/}}
{{- define "invenio.rabbitmq.password" -}}
  {{- if .Values.rabbitmq.enabled }}
    {{- required "Missing .Values.rabbitmq.auth.password" .Values.rabbitmq.auth.password -}}
  {{- else }}
    {{- required "Missing .Values.rabbitmqExternal.password" .Values.rabbitmqExternal.password -}}
  {{- end }}
{{- end -}}

##########################     RabbitMQ AMQP port     ##########################
{{/*
  This template renders the AMQP port number for RabbitMQ.
*/}}
{{- define "invenio.rabbitmq.amqpPort" -}}
  {{- if .Values.rabbitmq.enabled }}
    {{- required "Missing .Values.rabbitmq.service.ports.amqp" .Values.rabbitmq.service.ports.amqp -}}
  {{- else }}
    {{- required "Missing .Values.rabbitmqExternal.amqpPort" .Values.rabbitmqExternal.amqpPort -}}
  {{- end }}
{{- end -}}

#######################     RabbitMQ management port     #######################
{{/*
  This template renders the management port number for RabbitMQ.
*/}}
{{- define "invenio.rabbitmq.managementPort" -}}
  {{- if .Values.rabbitmq.enabled }}
    {{- required "Missing .Values.rabbitmq.service.ports.manager" .Values.rabbitmq.service.ports.manager -}}
  {{- else }}
    {{- required "Missing .Values.rabbitmqExternal.managementPort" .Values.rabbitmqExternal.managementPort -}}
  {{- end }}
{{- end -}}

##########################     RabbitMQ hostname     ##########################
{{/*
  This template renders the hostname for RabbitMQ.
*/}}
{{- define "invenio.rabbitmq.hostname" -}}
  {{- if .Values.rabbitmq.enabled }}
    {{- include "common.names.fullname" .Subcharts.rabbitmq -}}
  {{- else }}
    {{- required "Missing .Values.rabbitmqExternal.hostname" .Values.rabbitmqExternal.hostname }}
  {{- end }}
{{- end -}}

##########################     Celery broker URI     ##########################
{{/*
  This template renders the URI for connecting to RabbitMQ.
*/}}
{{- define "invenio.rabbitmq.uri" -}}
  {{- $username := (include "invenio.rabbitmq.username" .) -}}
  {{- $password := (include "invenio.rabbitmq.password" .) -}}
  {{- $port := (include "invenio.rabbitmq.amqpPort" .) -}}
  {{- $hostname := (include "invenio.rabbitmq.hostname" .) -}}
  {{- printf "amqp://%s:%s@%s:%v/" $username $password $hostname $port }}
{{- end -}}

###########################     RabbitMQ API URI     ###########################
{{/*
  This template renders the URI for RabbitMQ's API endpoint.
*/}}
{{- define "invenio.rabbitmq.apiUri" -}}
  {{- $username := (include "invenio.rabbitmq.username" .) -}}
  {{- $password := (include "invenio.rabbitmq.password" .) -}}
  {{- $port := (include "invenio.rabbitmq.managementPort" .) -}}
  {{- $hostname := (include "invenio.rabbitmq.hostname" .) -}}
  {{- printf "http://%s:%s@%s:%v/api/" $username $password $hostname $port }}
{{- end -}}

#########################     OpenSearch hostname     #########################
{{/*
  This template renders the hostname of the OpenSearch instance.
*/}}
{{- define "invenio.opensearch.hostname" -}}
  {{- if .Values.opensearch.enabled }}
    {{- include "opensearch.service.name" .Subcharts.opensearch -}}
  {{- else }}
    {{- required "Missing .Values.opensearchExternal.hostname" .Values.opensearchExternal.hostname -}}
  {{- end }}
{{- end -}}

#########################     PostgreSQL username     #########################
{{/*
  This template renders the username used for the PostgreSQL instance.
*/}}
{{- define "invenio.postgresql.username" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- required "Missing .Values.postgresql.auth.username" .Values.postgresql.auth.username -}}
    {{/* NOTE: Specifying username explicitly like this is suboptmal. Would be desirable to refactor Invenio so it can take the postgres username as a spearate environment variable which we can populate dynamically from the secret. */}}
  {{- else -}}
    {{- required "Missing .Values.postgresqlExternal.username" .Values.postgresqlExternal.username -}}
  {{- end -}}
{{- end -}}

#########################     PostgreSQL password     #########################
{{/*
  This template renders the password used for the PostgreSQL instance.
*/}}
{{- define "invenio.postgresql.password" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- required "Missing .Values.postgresql.auth.password" .Values.postgresql.auth.password -}}
    {{/* NOTE: Specifying password explicitly like this is suboptmal. Would be desirable to refactor Invenio so it can take the postgres password as a spearate environment variable which we can populate dynamically from the secret. */}}
  {{- else -}}
    {{- required "Missing .Values.postgresqlExternal.password" .Values.postgresqlExternal.password -}}
  {{- end -}}
{{- end -}}

#########################     PostgreSQL hostname     #########################
{{/*
  This template renders the hostname used for the PostgreSQL instance.
*/}}
{{- define "invenio.postgresql.hostname" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- include "postgresql.v1.primary.fullname" .Subcharts.postgresql -}}
  {{- else -}}
    {{- required "Missing .Values.postgresqlExternal.hostname" .Values.postgresqlExternal.hostname -}}
  {{- end -}}
{{- end -}}

###########################     PostgreSQL port     ###########################
{{/*
  This template renders the port number used for the PostgreSQL instance.
*/}}
{{- define "invenio.postgresql.port" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- required "Missing .Values.postgresql.primary.service.ports.postgresql" .Values.postgresql.primary.service.ports.postgresql -}}
  {{- else -}}
    {{- required "Missing .Values.postgresqlExternal.port" .Values.postgresqlExternal.port -}}
  {{- end -}}
{{- end -}}

############################     Database name     ############################
{{/*
  This template renders the name of the database in PostgreSQL.
*/}}
{{- define "invenio.postgresql.databaseName" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- required "Missing .Values.postgresql.auth.database" .Values.postgresql.auth.database -}}
  {{- else -}}
    {{- required "Missing .Values.postgresqlExternal.databaseName" .Values.postgresqlExternal.databaseName -}}
  {{- end -}}
{{- end -}}

#######################     SQLAlchemy database URI     #######################
{{/*
  This template renders the SQLAlchemy database URI.
*/}}
{{- define "invenio.sqlAlchemyDbUri" -}}
  {{- $username := include "invenio.postgresql.username" . -}}
  {{- $password := include "invenio.postgresql.password" . -}}
  {{- $hostname := include "invenio.postgresql.hostname" . -}}
  {{- $port := include "invenio.postgresql.port" . -}}
  {{- $databaseName := include "invenio.postgresql.databaseName" . -}}
  {{- printf "postgresql+psycopg2://%s:%s@%s:%v/%s" $username $password $hostname $port $databaseName -}}
{{- end -}}
