# Troubleshooting Embedded Ansible

This chapter contains

## Troubleshooting the Embedded Ansible Engine (AWX)


### AWX processes 

The AWX processes are managed by supervisord:

```
# supervisorctl
exit-event-listener                     RUNNING   pid 17390, uptime 20 days, 3:15:47
tower-processes:awx-callback-receiver   RUNNING   pid 17394, uptime 20 days, 3:15:47
tower-processes:awx-celeryd             RUNNING   pid 17396, uptime 20 days, 3:15:47
tower-processes:awx-celeryd-beat        RUNNING   pid 17395, uptime 20 days, 3:15:47
tower-processes:awx-channels-worker     RUNNING   pid 17391, uptime 20 days, 3:15:47
tower-processes:awx-daphne              RUNNING   pid 17393, uptime 20 days, 3:15:47
tower-processes:awx-uwsgi               RUNNING   pid 17392, uptime 20 days, 3:15:47
supervisor>
```


### AWX services
```
systemctl status supervisord
systemctl status nginx
systemctl status rabbitmq-server
```


### Rails console checks

The Rails `EmbeddedAnsible.new.running?` method checks that the supervisord, nginx and rabbitmq-server services are running correctly.

```
irb(main):001:0> EmbeddedAnsible.new.running?
=> true
```

The Rails `EmbeddedAnsible.new.alive?` method pings the Ansible server using the auto-configured credentials. This verifies that the credentials are setup correctly.

```
irb(main):002:0> EmbeddedAnsible.new.alive?
=> true
irb(main):003:0>
```


### Ansible Tower logs

```
/var/log/supervisor/
/var/log/tower/
```

Also there is some logging within evm.log located /var/www/miq/vmdb/log/

Supervisord configuration for Tower is located in _/etc/supervisord.d/tower.ini_

AWX installation was executed from _/opt/ansible-installer/_

### AWX Authentication Settings

The AWX password is randomly generated during role enabling/installation.
The admin creds are used to access the ansibleapi, use rails console to retrieve the password using:

```
irb(main):003:0> MiqDatabase.first.ansible_admin_authentication.password
=> "TxaUkrPwmLWNMCDyyimVSL8b"
```

Ansible Inside license is also randomly generated during this initial configuration.

## Troubleshooting the Embedded Ansible Jobs

### Log Files

Each time an embedded Ansible playbook runs up to three _.out_ files are created in _/var/lib/awx/job\_status_ on the CFME or ManageIQ appliance with the active **Embedded Ansible** role. The first two of these files show the results of synchronising the git repository and updating any roles, and the last file contains the output from the automation playbook itself. Depending on the

```
...
-rw-r--r--. 1 awx awx  7168 Jul 30 17:19 823-53c83b2a-9414-11e8-a6de-001a4aa01501.out
-rw-r--r--. 1 awx awx  7163 Jul 30 17:19 824-59a348dc-9414-11e8-bace-001a4aa01501.out
-rw-r--r--. 1 awx awx  5759 Jul 30 17:19 822-60bfda04-9414-11e8-bace-001a4aa01501.out
-rw-r--r--. 1 awx awx  7168 Jul 30 17:33 826-378d7702-9416-11e8-bace-001a4aa01501.out
-rw-r--r--. 1 awx awx  7163 Jul 30 17:33 827-3f1e09be-9416-11e8-93f2-001a4aa01501.out
-rw-r--r--. 1 awx awx 10583 Jul 30 17:33 825-4658561c-9416-11e8-93f2-001a4aa01501.out
-rw-r--r--. 1 awx awx  7168 Jul 30 17:59 829-ef7043e2-9419-11e8-a6de-001a4aa01501.out
-rw-r--r--. 1 awx awx  7163 Jul 30 17:59 830-f55b1d04-9419-11e8-93f2-001a4aa01501.out
-rw-r--r--. 1 awx awx 11216 Jul 30 18:00 828-fbb33088-9419-11e8-93f2-001a4aa01501.out
[root@cloudforms job_status]#
```

### Log output to evm.log


### Logging Verbosity

### Max_ttl too short

https://access.redhat.com/articles/3055471

https://mojo.redhat.com/docs/DOC-1153940


### Virtual Environment

/var/lib/awx/venv

```
source /var/lib/awx/venv/ansible/bin/activate
umask 0022
pip install --upgrade pywinrm
deactivate
```


### Appliance not responding

```
TASK [syncrou.manageiq-automate : Initialize the Workspace] ********************
An exception occurred during task execution. To see the full traceback, use -vvv. The error was: AttributeError: 'NoneType' object has no attribute 'read'
fatal: [localhost]: FAILED! => {"changed": false, "failed": true, "module_stderr": "Traceback (most recent call last):\n  File \"/tmp/ansible_xVSkWs/ansible_module_manageiq_automate.py\", line 510, in <module>\n    main()\n  File \"/tmp/ansible_xVSkWs/ansible_module_manageiq_automate.py\", line 502, in main\n    result = getattr(workspace, key)(value)\n  File \"/tmp/ansible_xVSkWs/ansible_module_manageiq_automate.py\", line 408, in initialize_workspace\n    workspace = self.get()\n  File \"/tmp/ansible_xVSkWs/ansible_module_manageiq_automate.py\", line 92, in get\n    return json.loads(result.read())\nAttributeError: 'NoneType' object has no attribute 'read'\n", "module_stdout": "", "msg": "MODULE FAILURE", "rc": 0}
```




## Summary

