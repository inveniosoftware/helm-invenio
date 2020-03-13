# -*- coding: utf-8 -*-
#
# Copyright (C) 2020 CERN.
#
# Invenio is free software; you can redistribute it and/or modify it under
# the terms of the MIT License; see LICENSE file for more details.

"""Locust file for a default Invenio instance stress testing.

Usage:
.. code-block:: console
  $ pip install locust

.. code-block:: console
  $ locust -f tests/locust/locustfile.py --host=http://0.0.0.0
  [2017-12-19 12:56:37,173] 127.0.0.1/INFO/locust.main: Starting web monitor \
  at *:8089
  [2017-12-19 12:56:37,175] 127.0.0.1/INFO/locust.main: Starting Locust 0.8
  ...
  $ firefox http://127.0.0.1:8089

If you need to run an specific set of tests:
.. code-block:: console
   $ locust -f tests/locust/locustfile.py Records --host=http://0.0.0.0
  [2017-12-19 12:56:37,173] 127.0.0.1/INFO/locust.main: Starting web monitor \
  at *:8089
  [2017-12-19 12:56:37,175] 127.0.0.1/INFO/locust.main: Starting Locust 0.8
  ...
  $ firefox http://127.0.0.1:8089
"""

from locust import HttpLocust, TaskSet, task, between

# The recid to query is not randomized because without caching
# there is no difference. When having a different recid queried the output
# of locust is not easily readable since the endpoints explode in a big list
RECID = 'h2kh0-vfq12'

# Assumes no record with pid 99999999999999 exists
NON_EXISTING_RECID = 9999

SEARCH_QUERY = "Baker"


class UIRecordsTaskSet(TaskSet):
    """Task set to carry out UI operations against the records endpoint.

    UI testing:
        - Existing record
        - Non-existing record
        - Random search
        - Full search
        - Malformed search
    """

    @task
    def ui_record_view(self):
        """UI Random record view."""
        self.client.get('/records/{}'.format(RECID))

    @task
    def ui_non_existing_record_view(self):
        """UI Non existing record with lower recid."""
        with self.client.get('/records/{}'.format(NON_EXISTING_RECID),
                             catch_response=True) as response:
            if response.status_code == 404:
                response.success()

    @task
    def ui_search_random(self):
        """UI Random search."""
        params = {'q': SEARCH_QUERY}
        self.client.get('/search', params=params)

    @task
    def ui_search_full(self):
        """UI full search."""
        self.client.get('/search')

    # @task
    # def ui_search_malformed(self):
    #     """UI malformed search."""
    #     params = {'q': "\"'"}
    #     with self.client.get('/search', params=params,
    #                          catch_response=True) as response:
    #         if response.status_code == 404:
    #             response.success()


class APIRecordsTaskSet(TaskSet):
    """Task set to carry out API operations against the records endpoint.

    API testing:
        - Random record
        - Random search
        - Non-existing record
        - Malformed search
        - Create record
        - Create malform record
    """

    @task
    def api_record_view(self):
        """API Random record view."""
        self.client.get('/api/records/{}'.format(RECID))

    @task
    def api_non_existing_record_view(self):
        """API Non existing record view lower."""
        with self.client.get('/api/records/{}'.format(NON_EXISTING_RECID),
                             catch_response=True) as response:
            if response.status_code == 404:
                response.success()

    @task
    def api_search_random(self):
        """API Random search."""
        params = {'q': SEARCH_QUERY}
        self.client.get('/api/records/', params=params)


    @task
    def api_search_full(self):
        """API Random search."""
        self.client.get('/api/records/')

    # @task
    # def api_search_malformed(self):
    #     """API Random search."""
    #     params = {'q': "\"'"}
    #     with self.client.get('/api/records/', params=params,
    #                          catch_response=True) as response:
    #         if response.status_code == 500:
    #             response.success()


class FilesTaskSet(TaskSet):
    """Task set to carry out operations against the files endpoint.

    UI testing:
        - Random record file preview

    API testing:
        - Create a light file
        - Create a heavy file
        - Request a heavy file
        - Request a light file
        - Request a record with a heavy file
        - Request a record with many light files
        - Request a record with several heavy files
    """

    pass


class UserTaskSet(TaskSet):
    """Task set to simulate a sample user interaction.

    UI testing:
        - Access frontpage
        - Random search
        - Complex search
        - Malformed search
        - Record search
        - Record view
        - Files view
        - Files download

    API testing:
        - Random search
        - Complex search
        - Malformed search
        - Record view
        - Files listing
        - Files download
        - Record creation
        - Malformed record creation
    """

    pass


class UIRecords(HttpLocust):
    task_set = UIRecordsTaskSet
    wait_time = between(1.0, 2.0)


class APIRecords(HttpLocust):
    task_set = APIRecordsTaskSet
    wait_time = between(1.0, 2.0)


class Files(HttpLocust):
    task_set = FilesTaskSet
    wait_time = between(1.0, 2.0)


class User(HttpLocust):
    task_set = UserTaskSet
    wait_time = between(1.0, 2.0)
