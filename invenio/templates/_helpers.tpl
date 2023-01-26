{{/*
Get the redis host name.
*/}}
{{- define "redis.host_name" -}}
{{- if not (.Values.redis.invenio.enabled) }}
    {{- if .Values.redis.invenio.host}}
        {{- printf "%s" (tpl .Values.redis.invenio.host $) -}}
    {{- else}}
        {{- printf "%s" "cache" -}}
    {{- end}}
{{- else -}}
    {{ printf "%s-master" (include "common.names.fullname" .Subcharts.redis) }}
{{- end -}}
{{- end -}}

{{/*
Get the rabbitmq host name.
*/}}
{{- define "rabbitmq.host_name" -}}
{{- if not (.Values.rabbitmq.invenio.enabled) }}
    {{- if .Values.rabbitmq.invenio.host}}
        {{- printf "%s" (tpl .Values.rabbitmq.invenio.host $) -}}
    {{- else}}
        {{- printf "%s" "mq" -}}
    {{- end}}
{{- else -}}
    {{ printf "%s" (include "common.names.fullname" .Subcharts.rabbitmq) }}
{{- end -}}
{{- end -}}

{{/*
Get the postgresql host name.
*/}}
{{- define "postgresql.host_name" -}}
{{- if not (.Values.postgresql.invenio.enabled) }}
    {{- if .Values.postgresql.invenio.host}}
        {{- printf "%s" (tpl .Values.postgresql.invenio.host $) -}}
    {{- else}}
        {{- printf "%s" "db" -}}
    {{- end}}
{{- else -}}
    {{ printf "%s" (include "postgresql.primary.fullname" .Subcharts.postgresql) }}
{{- end -}}
{{- end -}}

{{/*
Get the search host name.
*/}}
{{- define "search.host_name" -}}
{{- if not (.Values.search.invenio.enabled) }}
    {{- if .Values.search.invenio.host}}
        {{- printf "%s" (tpl .Values.search.invenio.host $) -}}
    {{- else}}
        {{- printf "%s" "search" -}}
    {{- end}}
{{- else -}}
    {{ printf "%s" (include "opensearch.serviceName" .Subcharts.search) }}
{{- end -}}
{{- end -}}
