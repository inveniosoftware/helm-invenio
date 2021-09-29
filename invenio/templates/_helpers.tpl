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