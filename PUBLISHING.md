# Publishing new versions of Helm-Invenio

## 1. Clone de repository

``` console
$ git clone https://github.com/inveniosoftware/helm-invenio.git
$ cd helm-invenio/
```

## 2. Upgrade chart version

Upgrade the version in the `invenio/Chart.yaml` file:

``` yaml
# Chart version.
version: 0.1.0
```

And create the new package:

``` console
$ helm package invenio/* -d .deploy
```

:note: the `.deploy` folder will be created but not commited since it is part of the `.gitignore` file.

## 3. Upload the release to GitHub

The next step is to upload the release to GitHub, for that we will use the [chart-releaser](https://github.com/helm/chart-releaser) tool. You can use it via docker, by mounting the `helm-invenio` repository folder:

``` console
$ docker run -v /absolute/path/to/helm-invenio:/tmp/invenio/ -it quay.io/helmpack/chart-releaser:v0.2.3 /bin/sh
```

Before proceeding we need to generate a new personal token with access to the repository (*repo* group). You can do so in [here](https://github.com/settings/tokens).

``` console
$ cr upload -o inveniosoftware -r helm-invenio -p .deploy -t  <TOKEN>
```

:warning: the `.deploy` folder should only contain new releases, otherwise chart-releaser will try to push them all and will fail due to "already existing" versions.

And finally we should update the chart `index.yaml` file, that will be served to `helm`:

``` console
$ cr index -i ./index.yaml -p .deploy/ -o inveniosoftware -c https://github.com/inveniosoftware/helm-invenio -r helm-invenio --token <TOKEN>
$ git add index.yaml
$ git commit -m 'release: v0.1.0'
```

:warning: The `index.yaml` file should be appended with the new versions, however chart-releaser overwrites it. There is [an open issue](https://github.com/helm/chart-releaser/issues/46) to remedy that situation.

Once the GitHub pages have been updated you can see the new release in helm:

First add the repository if you do not have it:

``` console
$ helm repo add helm-invenio https://inveniosoftware.github.io/helm-invenio/
```

Then update it and search:

``` console
$ helm repo update
$ helm search invenio
NAME                   	CHART VERSION	APP VERSION	DESCRIPTION
helm-invenio/invenio	0.1.0        	1.16.0     	Open Source framework for large-scale digital repositories
```
