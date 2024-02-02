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
    {{- required "Missing .Values.host" .Values.host -}}-tls
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
