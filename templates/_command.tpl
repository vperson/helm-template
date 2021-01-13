{{- define "container.command" }}
          command:
            - java
            {{- toYaml .Values.command | nindent 12 }}
            - -Duser.timezone=GMT+8
            - -jar
            - /{{ .Values.fullnameOverride }}-{{ .Values.image.tag }}.jar
            - --server.version={{ .Values.image.tag }}
            - --info.version={{ .Values.image.tag }}
{{- end }}