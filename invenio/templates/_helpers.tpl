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