{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "project.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "project.fullname" -}}
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
{{- define "project.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "project.labels" -}}
helm.sh/chart: {{ include "project.chart" . }}
{{ include "project.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "project.selectorLabels" -}}
app.kubernetes.io/name: {{ include "project.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "project.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "project.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return true if the configmap object should be created
*/}}
{{- define "project.createConfigMap" -}}
{{- if (not .Values.config.existingName) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the configMap
*/}}
{{- define "project.configMapName" -}}
{{- if .Values.config.existingName -}}
    {{- printf "%s" .Values.config.existingName -}}
{{- else -}}
    {{- printf "%s" (include "project.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if the secret object should be created
*/}}
{{- define "project.createSecret" -}}
{{- if (not .Values.secret.existingName) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the secret
*/}}
{{- define "project.secretName" -}}
{{- if .Values.secret.existingName -}}
    {{- printf "%s" .Values.secret.existingName -}}
{{- else -}}
    {{- printf "%s" (include "project.fullname" .) -}}
{{- end -}}
{{- end -}}
