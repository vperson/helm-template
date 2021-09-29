{{/*
Expand the name of the chart.
*/}}
{{- define "get.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "get.fullname" -}}
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
{{- define "get.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
公共标签,目前先不使用
{{- define "get.labels" -}}
helm.sh/chart: {{ include "get.chart" . }}
{{ include "get.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
*/}}

{{- define "get.labels" -}}
{{ include "get.selectorLabels" . }}
chart: {{ .Chart.Name }}
environment: {{ .Values.environment }}
{{- end }}


{{/*
Selector labels
不要把version加入到这里,为了以后可以同一个svc,多个deployment
*/}}
{{- define "get.selectorLabels" -}}
app: {{ include "get.name" . }}
{{- if ne  .Release.Name "RELEASE-NAME" }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
{{- end }}

{{/*
创建一个serviceAccount使用的Name,依赖引用get.fullname模板
*/}}
{{- define "get.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "get.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
 获取namespace值
*/}}
{{- define "get.namespace" }}
  {{- if .Values.namespaceOverride -}}
    {{- .Values.namespaceOverride -}}
  {{- else -}}
    {{- .Release.Namespace -}}
  {{- end -}}
{{- end -}}


{{/*
获取version标签
*/}}
{{- define "get.istio.version" -}}
version: {{ default "latest" .Values.serviceAccount.name }}
{{- end -}}

{{/*
downwardAPI配置
*/}}
{{- define "get.downward.api" -}}
{{- if .Values.downwardAPI.enabled }}
{{- if eq .Values.downwardAPI.type "env" -}}
- name: MY_NODE_NAME
  valueFrom:
    fieldRef:
      fieldPath: spec.nodeName
- name: MY_POD_NAME
  valueFrom:
    fieldRef:
      fieldPath: metadata.name
- name: MY_POD_NAMESPACE
  valueFrom:
    fieldRef:
      fieldPath: metadata.namespace
- name: MY_POD_IP
  valueFrom:
    fieldRef:
      fieldPath: status.podIP
- name: MY_POD_SERVICE_ACCOUNT
  valueFrom:
    fieldRef:
      fieldPath: spec.serviceAccountName
{{- else if eq .Values.downwardAPI.type "file" }}
- name: podinfo
  downwardAPI:
    items:
      - path: "node_name"
        fieldRef:
          fieldPath: spec.nodeName
      - path: "pod_name"
        fieldRef:
          fieldPath: metadata.name
      - path: "pod_namespace"
        fieldRef:
          fieldPath: metadata.namespace
      - path: "pod_ip"
        fieldRef:
          fieldPath: status.podIP
      - path: "pod_service_account"
        fieldRef:
          fieldPath: spec.serviceAccountName 
{{- else}}
{{- end -}}
{{- end -}}
{{- end -}}

