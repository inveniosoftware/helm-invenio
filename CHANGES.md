# Changes

Version 0.2.0 (2022-12-16)

* adds serving `/robots.txt` in nginx configuration
* adds missing secrets `SECURITY_LOGIN_SALT` and `CSRF_SECRET_SALT`
* improves HaProxy configuration to split max conn between backend and static backends
* allows to configure e-mails in Invenio adding needed values
* improves readiness/liveness probes
* splits worker and beat in 2 different containers
* allows to inject extra configuration in Invenio containers

Version 0.1.0 (2022-10-05)

* initial version for InvenioRDM v10
