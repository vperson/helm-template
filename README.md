# helm-template
可以自动生成Kubernetes部署文件

## 生成默认的部署文件
```shell script
# helm template . --set image.tag=v1.0.0
```

## 生成开发环境的部署文件
```shell script
# helm template -f dev-values.yaml . --set image.tag=v1.0.0
```