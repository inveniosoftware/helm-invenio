# -*- coding: utf-8 -*-
#
# Copyright (C) 2020 CERN.
#
# My site is free software; you can redistribute it and/or modify it under
# the terms of the MIT License; see LICENSE file for more details.

"""Command-line tools for demo module."""

import uuid

import click
from faker import Faker
from flask.cli import with_appcontext
from invenio_db import db
from invenio_indexer.api import RecordIndexer
from invenio_pidstore import current_pidstore
from invenio_records_files.api import Record
from invenio_search import current_search
import timeit


def create_fake_record(bulk_size, fake):
    """Create records for demo purposes."""
    records_bulk = []
    start = timeit.default_timer()
    for _ in range(bulk_size):
        # Create fake record metadata
        record_data = {
                "contributors": [{"name": fake.name()}],
                "description": fake.bs(),
                "title": fake.company() + "'s dataset",
            }

        # Create record in DB
        rec_uuid = uuid.uuid4()
        current_pidstore.minters["recid"](rec_uuid, record_data)
        Record.create(record_data, id_=rec_uuid)

        # Add record for bulk indexing
        records_bulk.append(rec_uuid)

    # Flush to index and database
    db.session.commit()
    click.secho(f"Writing {bulk_size} records to the database", fg="green")

    # Bulk index records
    ri = RecordIndexer()
    ri.bulk_index(records_bulk)
    current_search.flush_and_refresh(index="records")
    click.secho(f"Sending {bulk_size} records to be indexed", fg="green")
    stop = timeit.default_timer()
    click.secho(f"Creating {bulk_size} records took {stop - start}.",
                fg="green")


@click.group()
def demo():
    """Invenio records commands."""
    pass


@demo.command("create")
@click.argument("bulk_size", nargs=1, type=click.INT)
@click.argument("bulk_num", nargs=1, type=click.INT)
@with_appcontext
def create(bulk_size, bulk_num):
    """Create fake records in bulk. Create `bulk_size` * `bulk_num` records."""
    click.secho("Creating records...", fg="blue")

    fake = Faker()

    for _ in range(bulk_num):
        create_fake_record(bulk_size, fake)

    click.secho("Records created!", fg="green")
    click.secho("Run the following command to index the craeted records\n"
                "\tinvenio index run -d", fg="blue")
