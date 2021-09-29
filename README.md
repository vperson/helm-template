# helm-template
helm-template是一个用于生成kubernetes部署文件的模板仓库。如果有一定的helm基础对其进行简单的配置即可使用，目前支持生成service、
serviceaccount、deployment、hpa资源。


# 如何使用
```shell
$ tree .
.
├── Chart.yaml
├── README.md
├── charts
├── templates
│   ├── NOTES.txt
│   ├── _helpers.tpl
│   ├── deployment.yaml
│   ├── hpa.yaml
│   ├── ingress.yaml
│   ├── service.yaml
│   └── serviceaccount.yaml
└── values.yaml

2 directories, 10 files
```

通过tree命令我们可以看到项目的目录结构和helm create project 几乎是一样的没有任何差别。

通过简单的修改values.yaml即可使用。

修改values.yaml中的以下参数：
* hub: 指定容器镜像仓库地址,比如阿里云的 registry.cn-hangzhou.aliyuncs.com
* nameOverride: 修改成应用的名字，会影响生成的资源对象的命名
* fullnameOverride: 建议设置成和nameOverride一样的值
* namespaceOverride: 不指定的情况下使用default


生成模板
```shell
helm template .
```

一般情况下我们更新最多的就是image的tag了，每次生成的时候不需要手动修改values.yaml的值，只需要通过helm的命令行传参就可以：
```shell
helm template . --set image.tag=v1.0.0
```

# 支持的功能
* 创建serviceAccount
* 环境变量的注入
* 资源限制
* volumes挂载
* downwardAPI
* hostAliases
* sidecar
* initContainerss

PS: 日常常用到的都已经抽象到values.yaml中了

# 多环境使用
如果一个项目有过个环境怎么办，是不是要修改values.yaml？

如果有多个环境不需要修改values.yaml中的内容，因为values.yaml的值，我们认定为一个应用的默认值，一般不做修改。如果有多个环境，我们可以创建
多个values.yaml，然后在生成或者部署的时候通过helm 的 -f参数进行指定，这样helm会先读取项目中的values.yaml的内容，再读取-f指定的文件，
用-f参数指定的文件中的值覆盖valeus.yaml中的值。



# 多项目使用推荐
如果多个项目使用helm部署使用一般有两种方式：

### 方案一（不推荐）
在helm-template中为每个项目创建xxx-values.yaml的文件，所有项目公用一个公共的默认值
这样做的好处就是我们只需要维护一份templates下面的文件；缺点也是很明显的，后期如果做了修改templates中的逻辑会变的非常的复杂


### 方案二（推荐）
所有项目都以helm-templates仓库为基础，比如我想在需要创建一个应用app-a，那我就把helm-template仓库克隆下来，然后修改最外层的目录为
app-a，修改Chart.yaml中的name为app-a,修改values.yaml中的fullnameOverride和nameOverride，这样一个应用就创建好了，每个应用的templates也是
独立的修改了不会影响其他应用。
