{{/*
Get the redis host name.
*/}}
{{- define "redis.host_name" -}}
{{- if .Values.redis.host }}
    {{- printf "%s" (tpl .Values.redis.host $) -}}
{{- else -}}
    {{- `cache` -}}
{{- end -}}
{{- end -}}

{{/*
Get the rabbitmq secret name.
*/}}
{{- define "rabbitmq.secret_name" -}}
{{- if .Values.rabbitmq.existing_secret }}
    {{- printf "%s" (tpl .Values.rabbitmq.existing_secret $) -}}
{{- else -}}
    {{- `mq-secrets` -}}
{{- end -}}
{{- end -}}

{{/*
Return true if we should use an existing secret for rabbitmq configuration.
*/}}
{{- define "rabbitmq.use_existing_secret" -}}
{{- if .Values.postgresql.existing_secret -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created
*/}}
{{- define "rabbitmq.create_secret" -}}
{{- if not (include "rabbitmq.use_existing_secret" .) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Get the postgresql secret name.
*/}}
{{- define "postgresql.secret_name" -}}
{{- if .Values.postgresql.existing_secret }}
    {{- printf "%s" (tpl .Values.postgresql.existing_secret $) -}}
{{- else -}}
    {{- `db-secrets` -}}
{{- end -}}
{{- end -}}

{{/*
Return true if we should use an existing secret for postgresql configuration.
*/}}
{{- define "postgresql.use_existing_secret" -}}
{{- if .Values.postgresql.existing_secret -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created for postgresql configuration.
*/}}
{{- define "postgresql.create_secret" -}}
{{- if not (include "postgresql.use_existing_secret" .) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Get the postgresql secret name.
*/}}
{{- define "elasticsearch.secret_name" -}}
{{- if .Values.elasticsearch.existing_secret }}
    {{- printf "%s" (tpl .Values.elasticsearch.existing_secret $) -}}
{{- else -}}
    {{- `elasticsearch-secrets` -}}
{{- end -}}
{{- end -}}

{{/*
Return true if we should use an existing secret for elasticsearch configuration.
*/}}
{{- define "elasticsearch.use_existing_secret" -}}
{{- if .Values.elasticsearch.existing_secret -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created for elasticsearch configuration.
*/}}
{{- define "elasticsearch.create_secret" -}}
{{- if not (include "elasticsearch.use_existing_secret" .) -}}
    {{- true -}}
{{- end -}}
{{- end -}}
