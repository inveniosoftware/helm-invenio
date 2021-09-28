{{/*
Get the password secret.
*/}}
{{- define "postgresql.secret_name" -}}
{{- if .Values.postgresql.existing_secret }}
    {{- printf "%s" (tpl .Values.postgresql.existing_secret $) -}}
{{- else -}}
    {{- `"db-secrets"` -}}
{{- end -}}
{{- end -}}

{{/*
Return true if we should use an existingSecret.
*/}}
{{- define "postgresql.use_existing_secret" -}}
{{- if .Values.postgresql.existing_secret -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created
*/}}
{{- define "postgresql.create_secret" -}}
{{- if not (include "postgresql.use_existing_secret" .) -}}
    {{- true -}}
{{- end -}}
{{- end -}}
