{{/*
Expand the name of the chart.
*/}}
{{- define "invenio.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name, the release name will be used as a full name.
*/}}
{{- define "invenio.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "invenio.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "invenio.selectorLabels" -}}
app.kubernetes.io/name: {{ include "invenio.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "invenio.labels" -}}
helm.sh/chart: {{ include "invenio.chart" . }}
{{ include "invenio.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

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

#######################     RabbitMQ connection configuration     #######################
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

{{/*
  This template renders the username for accessing RabbitMQ.
*/}}
{{- define "invenio.rabbitmq.username" -}}
  {{- if .Values.rabbitmq.enabled }}
    {{- required "Missing .Values.rabbitmq.auth.username" .Values.rabbitmq.auth.username -}}
  {{- else }}
    {{- required "Missing .Values.rabbitmqExternal.username" (tpl .Values.rabbitmqExternal.username .) -}}
  {{- end }}
{{- end -}}

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

{{/*
  Get the database password secret name
*/}}
{{- define "invenio.rabbitmq.secretName" -}}
  {{- if .Values.rabbitmq.enabled -}}
    {{- required "Missing .Values.rabbitmq.auth.existingPasswordSecret" (tpl .Values.rabbitmq.auth.existingPasswordSecret .) -}}
  {{- else -}}
    {{- required "Missing .Values.rabbitmqExternal.existingSecret" (tpl .Values.rabbitmqExternal.existingSecret .) -}}
  {{- end -}}
{{- end -}}

{{/*
  Get the database password secret key
*/}}
{{- define "invenio.rabbitmq.secretKey" -}}
  {{- if .Values.rabbitmq.enabled -}}
    {{- required "Missing .Values.rabbitmq.auth.existingSecretPasswordKey" .Values.rabbitmq.auth.existingSecretPasswordKey -}}
  {{- else -}}
    {{- required "Missing .Values.rabbitmqExternal.existingSecretPasswordKey" .Values.rabbitmqExternal.existingSecretPasswordKey -}}
  {{- end -}}
{{- end -}}

{{/*
  This template renders the AMQP port number for RabbitMQ.
*/}}
{{- define "invenio.rabbitmq.amqpPort" -}}
  {{- if .Values.rabbitmq.enabled }}
    {{- required "Missing .Values.rabbitmq.service.ports.amqp" .Values.rabbitmq.service.ports.amqp | quote -}}
  {{- else }}
    {{- required "Missing .Values.rabbitmqExternal.amqpPort" (tpl .Values.rabbitmqExternal.amqpPort .) | quote -}}
  {{- end }}
{{- end -}}

{{/*
  This template renders the management port number for RabbitMQ.
*/}}
{{- define "invenio.rabbitmq.managementPort" -}}
  {{- if .Values.rabbitmq.enabled }}
    {{- required "Missing .Values.rabbitmq.service.ports.manager" .Values.rabbitmq.service.ports.manager | quote -}}
  {{- else }}
    {{- required "Missing .Values.rabbitmqExternal.managementPort" (tpl .Values.rabbitmqExternal.managementPort .) | quote -}}
  {{- end }}
{{- end -}}

{{/*
  This template renders the hostname for RabbitMQ.
*/}}
{{- define "invenio.rabbitmq.hostname" -}}
  {{- if .Values.rabbitmq.enabled }}
    {{- include "common.names.fullname" .Subcharts.rabbitmq -}}
  {{- else }}
    {{- required "Missing .Values.rabbitmqExternal.hostname" (tpl .Values.rabbitmqExternal.hostname .) }}
  {{- end }}
{{- end -}}

{{/*
  This template renders the protocol for RabbitMQ.
*/}}
{{- define "invenio.rabbitmq.protocol" -}}
  {{- if .Values.rabbitmq.enabled }}
    {{- "amqp" }}
  {{- else }}
    {{- required "Missing .Values.rabbitmqExternal.protocol" .Values.rabbitmqExternal.protocol }}
  {{- end }}
{{- end -}}

{{/*
  This template renders the vhost for RabbitMQ.
*/}}
{{- define "invenio.rabbitmq.vhost" -}}
  {{- if .Values.rabbitmq.enabled }}
    {{- "" }}
  {{- else }}
    {{- required "Missing .Values.rabbitmqExternal.vhost" (tpl .Values.rabbitmqExternal.vhost .) }}
  {{- end }}
{{- end -}}

{{/*
  RabbitMQ connection env section. 
*/}}
{{- define "invenio.config.queue" -}}
{{- $uri := "$(INVENIO_AMQP_BROKER_PROTOCOL)://$(INVENIO_AMQP_BROKER_USER):$(INVENIO_AMQP_BROKER_PASSWORD)@$(INVENIO_AMQP_BROKER_HOST):$(INVENIO_AMQP_BROKER_PORT)/$(INVENIO_AMQP_BROKER_VHOST)" -}}
- name: INVENIO_AMQP_BROKER_USER
  value: {{ include "invenio.rabbitmq.username" . }}
- name: INVENIO_AMQP_BROKER_HOST
  value: {{ include "invenio.rabbitmq.hostname" . }}
- name: INVENIO_AMQP_BROKER_PORT
  value: {{ include "invenio.rabbitmq.amqpPort" . }}
- name: INVENIO_AMQP_BROKER_VHOST
  value: {{ include "invenio.rabbitmq.vhost" . }}
- name: INVENIO_AMQP_BROKER_PROTOCOL
  value: {{ include "invenio.rabbitmq.protocol" . }}
- name: INVENIO_AMQP_BROKER_PASSWORD
{{- if or (and .Values.rabbitmq.enabled .Values.rabbitmq.auth.password) .Values.rabbitmqExternal.password }}
  value: {{ include "invenio.rabbitmq.password" .  | quote }}
{{- else }}
  valueFrom:
    secretKeyRef:
      name: {{ include "invenio.rabbitmq.secretName" .}}
      key: {{ include "invenio.rabbitmq.secretKey" .}}
{{- end }}
- name: INVENIO_BROKER_URL
  value: {{ $uri}}
- name: INVENIO_CELERY_BROKER_URL
  value: {{ $uri}}
- name: RABBITMQ_API_URI
  value: "http://$(INVENIO_AMQP_BROKER_USER):$(INVENIO_AMQP_BROKER_PASSWORD)@$(INVENIO_AMQP_BROKER_HOST):$(INVENIO_AMQP_BROKER_PORT)/api/"
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

#########################     PostgreSQL connection configuration     #########################
{{/*
  This template renders the username used for the PostgreSQL instance.
*/}}
{{- define "invenio.postgresql.username" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- required "Missing .Values.postgresql.auth.username" (tpl .Values.postgresql.auth.username .) -}}
  {{- else -}}
    {{- required "Missing .Values.postgresqlExternal.username" (tpl  .Values.postgresqlExternal.username .) -}}
  {{- end -}}
{{- end -}}

{{/*
  This template renders the password used for the PostgreSQL instance.
  In production environments we encourage you to use secrets instead.
*/}}
{{- define "invenio.postgresql.password" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- required "Missing .Values.postgresql.auth.password" .Values.postgresql.auth.password -}}
  {{- else -}}
    {{- required "Missing .Values.postgresqlExternal.password" .Values.postgresqlExternal.password -}}
  {{- end -}}
{{- end -}}

{{/*
  Get the database password secret name
*/}}
{{- define "invenio.postgresql.secretName" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- required "Missing .Values.postgresql.auth.existingSecret" (tpl .Values.postgresql.auth.existingSecret .) -}}
  {{- else -}}
    {{- required "Missing .Values.postgresqlExternal.existingSecret" (tpl .Values.postgresqlExternal.existingSecret .) -}}
  {{- end -}}
{{- end -}}

{{/*
  Get the database password secret key
*/}}
{{- define "invenio.postgresql.secretKey" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- required "Missing .Values.postgresql.auth.secretKeys.userPasswordKey" .Values.postgresql.auth.secretKeys.userPasswordKey -}}
  {{- else -}}
    {{- required "Missing .Values.postgresqlExternal.existingSecretPasswordKey" .Values.postgresqlExternal.existingSecretPasswordKey -}}
  {{- end -}}
{{- end -}}

{{/*
  This template renders the hostname used for the PostgreSQL instance.
*/}}
{{- define "invenio.postgresql.hostname" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- include "postgresql.v1.primary.fullname" .Subcharts.postgresql -}}
  {{- else -}}
    {{- required "Missing .Values.postgresqlExternal.hostname" (tpl .Values.postgresqlExternal.hostname .) -}}
  {{- end -}}
{{- end -}}

{{/*
  This template renders the port number used for the PostgreSQL instance.
*/}}
{{- define "invenio.postgresql.port" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- required "Missing .Values.postgresql.primary.service.ports.postgresql" (tpl (toString .Values.postgresql.primary.service.ports.postgresql) .) -}}
  {{- else -}}
    {{- required "Missing .Values.postgresqlExternal.port" (tpl (toString .Values.postgresqlExternal.port) .) -}}
  {{- end -}}
{{- end -}}

{{/*
  This template renders the name of the database in PostgreSQL.
*/}}
{{- define "invenio.postgresql.database" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- required "Missing .Values.postgresql.auth.database" (tpl .Values.postgresql.auth.database .) -}}
  {{- else -}}
    {{- required "Missing .Values.postgresqlExternal.database" (tpl .Values.postgresqlExternal.database .) -}}
  {{- end -}}
{{- end -}}

{{/*
  Define database connection env section. 
*/}}
{{- define "invenio.config.database" -}}
- name: INVENIO_DB_USER
  value: {{ include "invenio.postgresql.username" . }}
- name: INVENIO_DB_HOST
  value: {{ include "invenio.postgresql.hostname" . }}
- name: INVENIO_DB_PORT
  value: {{ include "invenio.postgresql.port" . | quote }}
- name: INVENIO_DB_NAME
  value: {{ include "invenio.postgresql.database" . }}
- name: INVENIO_DB_PROTOCOL
  value: "postgresql+psycopg2"
- name: INVENIO_DB_PASSWORD
{{- if or (and .Values.postgresql.enabled .Values.postgresql.auth.password) .Values.postgresqlExternal.password }}
  value: {{ include "invenio.postgresql.password" .  | quote }}
{{- else }}
  valueFrom:
    secretKeyRef:
      name: {{ include "invenio.postgresql.secretName" .}}
      key: {{ include "invenio.postgresql.secretKey" .}}
{{- end }}
- name: INVENIO_SQLALCHEMY_DATABASE_URI
  value: "$(INVENIO_DB_PROTOCOL)://$(INVENIO_DB_USER):$(INVENIO_DB_PASSWORD)@$(INVENIO_DB_HOST):$(INVENIO_DB_PORT)/$(INVENIO_DB_NAME)"
{{- end -}}

{{/*
Get the sentry secret name
*/}}
{{- define "invenio.sentrySecretName" -}}
{{- if .Values.invenio.sentry.existingSecret -}}
  {{- print (tpl .Values.invenio.sentry.existingSecret .) -}}
{{- else if  .Values.invenio.sentry.secret_name -}}
  {{- print .Values.invenio.sentry.secret_name -}}  
{{- else -}}
  {{- printf "%s-%s" (include "invenio.fullname" .) "sentry" -}}
{{- end -}}
{{- end -}}

{{/*
Add sentry environmental variables
*/}}
{{- define "invenio.config.sentry" -}}
{{- if .Values.invenio.sentry.enabled -}}
- name: INVENIO_SENTRY_DSN
  valueFrom:
    secretKeyRef:
      name: {{ include "invenio.sentrySecretName" . }}
      key: {{ .Values.invenio.sentry.secretKeys.dsnKey }}
{{- end }}
{{- end -}}

{{/*
Invenio basic configuration variables
*/}}
{{- define "invenio.configBase" -}}
INVENIO_ACCOUNTS_SESSION_REDIS_URL: 'redis://{{ include "invenio.redis.hostname" . }}:6379/1'
INVENIO_APP_ALLOWED_HOSTS: '["{{ include "invenio.hostname" $ }}"]'
INVENIO_CACHE_REDIS_HOST: '{{ include "invenio.redis.hostname" . }}'
INVENIO_CACHE_REDIS_URL: 'redis://{{ include "invenio.redis.hostname" . }}:6379/0'
INVENIO_CELERY_RESULT_BACKEND: 'redis://{{ include "invenio.redis.hostname" . }}:6379/2'
INVENIO_IIIF_CACHE_REDIS_URL: 'redis://{{ include "invenio.redis.hostname" . }}:6379/0'
INVENIO_RATELIMIT_STORAGE_URI: 'redis://{{ include "invenio.redis.hostname" . }}:6379/3'
INVENIO_COMMUNITIES_IDENTITIES_CACHE_REDIS_URL: 'redis://{{ include "invenio.redis.hostname" . }}:6379/4'
INVENIO_SEARCH_HOSTS: {{ printf "[{'host': '%s'}]" (include "invenio.opensearch.hostname" .) | quote }}
INVENIO_SITE_HOSTNAME: '{{ include "invenio.hostname" $ }}'
INVENIO_SITE_UI_URL: 'https://{{ include "invenio.hostname" $ }}'
INVENIO_SITE_API_URL: 'https://{{ include "invenio.hostname" $ }}/api'
INVENIO_DATACITE_ENABLED: "False"
INVENIO_LOGGING_CONSOLE_LEVEL: "WARNING"
{{- end -}}

{{/*
Merge invenio.extraConfig and configBase using mergeOverwrite and rendering templates.
invenio.ExtraConfig will overwrite the values from configBase in case of duplicates.
*/}}
{{- define "invenio.mergeConfig" -}}
{{- $dst := dict -}}
{{- $values := list (include "invenio.configBase" .)  (.Values.invenio.extra_config | toYaml) (.Values.invenio.extraConfig | toYaml) -}}
{{- range $values -}}
{{- $dst = tpl  . $ | fromYaml | mergeOverwrite $dst -}}
{{- end -}}
{{- $dst | toYaml -}}
{{- end -}}

{{/*
Get the invenio general secret name
*/}}
{{- define "invenio.secretName" -}}
{{- if .Values.invenio.existingSecret -}}
  {{- tpl .Values.invenio.existingSecret . -}}
{{- else -}}
  {{- include "invenio.fullname" . -}}
{{- end -}}
{{- end -}}
