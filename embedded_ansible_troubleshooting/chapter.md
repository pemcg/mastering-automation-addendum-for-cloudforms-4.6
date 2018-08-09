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

Also there is some logging within _/var/www/miq/vmdb/log/evm.log_

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

### Virtual Environment

AWX maintains all playbooks and python libraries in a virtual environment under _/var/lib/awx/venv_. To install or update anything in the virtual environment the `activate/deactivate` commands should be used, as follows:

```
source /var/lib/awx/venv/ansible/bin/activate
umask 0022
pip install --upgrade pywinrm
deactivate
```

## Troubleshooting the Embedded Ansible Jobs

### Job Log Files

Each time an embedded Ansible playbook runs, up to three _.out_ files are created in _/var/lib/awx/job\_status_ on the CFME or ManageIQ appliance with the active **Embedded Ansible** role. The first two of these files show the results of synchronising the git repository and updating any roles, and the last file contains the output from the automation playbook itself. Depending on the

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

The directory can be monitored for new files using the command `watch "ls -lrt | tail -10"`

### Log Output to _evm.log_

The option of whether to log playbook output to _evm.log_ can be made when the playbook service or method is created or edited (see [Adding an OpenStack Cloud Credential](#i1)).

![Adding an OpenStack Cloud Credential](images/screenshot1.png)

### Logging Verbosity

The desired log verbosity can be selected when the playbook service or method is created or edited (see [Setting Logging Verbosity](#i1)).

![Setting Logging Verbosity](images/screenshot2.png)

This log verbosity affects the output to the job _*.out_ file as well as any log output to _evm.log_.

### Max TTL Too Low

If the **Max TTL (mins)** value for a playbook method is too low the _ManageIQ::Providers::EmbeddedAnsible::AutomationManager::PlaybookRunner_ class will terminate the playbook job with an error such as:

```
Automation Error: job timed out after 96.890827024 seconds of inactivity. Inactivity threshold [60 seconds]
```

The  **Max TTL (mins)** value should be increased in the Ansible playbook method definition.

### Workspace Initialization Errors

The `manageiq-automate` and `manageiq-vmdb` modules can occasionally 

```
TASK [syncrou.manageiq-automate : Initialize the Workspace] ********************
An exception occurred during task execution. To see the full traceback, use -vvv. The error was: AttributeError: 'NoneType' object has no attribute 'read'
fatal: [localhost]: FAILED! => {"changed": false, "failed": true, "module_stderr": "Traceback (most recent call last):\n  File \"/tmp/ansible_xVSkWs/ansible_module_manageiq_automate.py\", line 510, in <module>\n    main()\n  File \"/tmp/ansible_xVSkWs/ansible_module_manageiq_automate.py\", line 502, in main\n    result = getattr(workspace, key)(value)\n  File \"/tmp/ansible_xVSkWs/ansible_module_manageiq_automate.py\", line 408, in initialize_workspace\n    workspace = self.get()\n  File \"/tmp/ansible_xVSkWs/ansible_module_manageiq_automate.py\", line 92, in get\n    return json.loads(result.read())\nAttributeError: 'NoneType' object has no attribute 'read'\n", "module_stdout": "", "msg": "MODULE FAILURE", "rc": 0}
```




## Summary



## Further Reading

[Debugging Ansible Automation Inside CloudForms](https://access.redhat.com/articles/3055471)