# Publishing new versions of the `invenio` Helm chart

1. Upgrade the `version` field in the `invenio/Chart.yaml` file.
1. Commit and tag:

    ```shell
    CHART_VERSION="$(yq .version "$(git rev-parse --show-toplevel)/charts/invenio/Chart.yaml")"
    git commit -s -m "📦 release: v${CHART_VERSION}"
    git tag "v${CHART_VERSION}"
    ```

1. Push:

    ```shell
    git push && git push --tags
    ```
