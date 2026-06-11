{{- define "sd.name" -}}
{{ .Chart.Name }}
{{- end -}}

{{- define "sd.labels" -}}
app.kubernetes.io/name: {{ include "sd.name" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/part-of: bian-platform
app.kubernetes.io/managed-by: {{ .Release.Service }}
bian/service-domain: {{ .Values.bian.serviceDomain }}
bian/business-area: {{ .Values.bian.businessArea }}
bian/business-domain: {{ .Values.bian.businessDomain }}
bian/functional-pattern: {{ .Values.bian.functionalPattern }}
{{- end -}}

{{- define "sd.selectorLabels" -}}
app.kubernetes.io/name: {{ include "sd.name" . }}
{{- end -}}
