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
