# Benchmarking an Invenio instance

## Populate your instance

:info: If you already have content in the instance this step is not needed.

We are going to create some demo records using a new CLI command. In order to do so, copy the `cli.py` file into `your_instance_package/cli.py`. If this file already existis, you can just copy its content.

Then add a commands entry point in your `setup.py`:

``` python
entry_points={
    'flask.commands': [
        'demo = your_instance_package.cli:demo',
    ],
    ...
}
```

Then, in order to use it you can just run `invenio` commands or launch the jobs in your deployment. Using the [provided job templates](../jobs):

The following job will create 3000 records, in 10 batchs of 300.

``` console
$ oc process -f job.yml --param JOB_NAME='demo-data' \
  --param JOB_COMMAND='invenio demo create 300 10' | oc create -f -
```

Afterwards, we will launch a job to index the created records. Note that it will only index the already crated records, so might want to wait until the previous job has finished. Alternatively, you can launch the following job several times and index partially until all records have been indexed.

``` console
$ oc process -f job.yml--param JOB_NAME=index-run \
  --param JOB_COMMAND=invenio index run -d | oc create -f -
```

## Benchmark

In order to test the load that your instance is able to stand, you can use the provided `locust.py` file.

First install locust:

``` console
$ pip install locust
```

Then launch the tests:

``` console
$ locust
```

Once it is running you can navigate to [the web interface](http://localhost:8089) and set the amount of users/and users joining per second. Play with the numbers until you reach the number of request per second (shown in the top right) that you are looking for.