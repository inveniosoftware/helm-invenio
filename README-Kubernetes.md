# [Beta] Invenio Helm chart: Kubernetes specifics

1. [Docker credentials](#docker-credentials)
2. [Routing](#routing)
2. [Instance setup](#instance-setup)

## Pre-requisites

- [Kubernetes Client](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Docker credentials

As you're working in a cloud environment and don't know to which node the image
is pulled, you have to define an `imagePullSecret`:

```bash
kubectl create secret docker-registry regsecret \
  --docker-server=DOCKERHOST_CHANGEME \
  --docker-username=DOCKERUSER_CHANGEME \ 
  --docker-password=DOCKERPASSWORD_CHANGEME \
  --docker-email=EMAIL_CHANGE_ME \
  --namespace invenio
```

You need to add this secret in your `values-overrides.yaml` file for every
place where the image is used. For example:

```yaml
web:
  image: your/invenio-image
  imagePullSecret: your/image-pull-secret
```

## Routing

Before installing you need to configure a few things in a
`values-overrides.yaml` file.

```yaml
ingress:
  sslSecretName: your-ssl-secret
```

The ingress is configured using the following variables:

Parameter | Description | Default
----------|-------------|--------
`ingress.enabled` | Whether to enable ingress | `true`
`ingress.class` | Class of the ingress if enabled | `nginx-internal`
`ingress.sslSecretName` | The ingress ssl secret for HTTPS | `your-ssl-secret`

## Instance setup

Get a bash terminal in a pod:

```bash
kubectl get pods --namespace invenio
kubectl exec -it <web-pod> bash --namespace invenio  # <web-pod> is found with the previous command
```

Then you can run invenio commands and setup your instance

```bash
. scl_source enable rh-python36
invenio db init # If the db does not exist already
invenio db create
invenio index init
invenio index queue init purge
invenio files location --default 'default-location'  $(invenio shell --no-term-title -c "print(app.instance_path)")'/data'
invenio roles create admin
invenio access allow superuser-access role admin
invenio rdm-records demo
```