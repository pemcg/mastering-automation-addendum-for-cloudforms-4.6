# Miscellaneous

This chapter contains

## Troubleshooting

Each time an embedded Ansible playbook runs up to three _.out_ files are created in _/var/lib/awx/job\_status_ on the CFME or ManageIQ appliance with the active **Embedded Ansible** role. The first two of these files show the results of synchronising the git repository and updating any roles, and the last file contains the output from the automation playbook itself. Depending on the

```
...
-rw-r--r--. 1 awx awx  7168 Jul 30 17:10 820-0b1059ae-9413-11e8-93f2-001a4aa01501.out
-rw-r--r--. 1 awx awx  7163 Jul 30 17:10 821-11f4203e-9413-11e8-93f2-001a4aa01501.out
-rw-r--r--. 1 awx awx  3587 Jul 30 17:10 819-19c2b208-9413-11e8-93f2-001a4aa01501.out
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

### Logging Verbosity


### Log output to evm.log

### Max_ttl too short


### Appliance not responding

```
TASK [syncrou.manageiq-automate : Initialize the Workspace] ********************
An exception occurred during task execution. To see the full traceback, use -vvv. The error was: AttributeError: 'NoneType' object has no attribute 'read'
fatal: [localhost]: FAILED! => {"changed": false, "failed": true, "module_stderr": "Traceback (most recent call last):\n  File \"/tmp/ansible_xVSkWs/ansible_module_manageiq_automate.py\", line 510, in <module>\n    main()\n  File \"/tmp/ansible_xVSkWs/ansible_module_manageiq_automate.py\", line 502, in main\n    result = getattr(workspace, key)(value)\n  File \"/tmp/ansible_xVSkWs/ansible_module_manageiq_automate.py\", line 408, in initialize_workspace\n    workspace = self.get()\n  File \"/tmp/ansible_xVSkWs/ansible_module_manageiq_automate.py\", line 92, in get\n    return json.loads(result.read())\nAttributeError: 'NoneType' object has no attribute 'read'\n", "module_stdout": "", "msg": "MODULE FAILURE", "rc": 0}
```


## Events

The following events are emitted from the embedded Ansible engine:

```
System/Event/EmsEvent/EMBEDDEDANSIBLE/job_create
System/Event/EmsEvent/EMBEDDEDANSIBLE/job_template_associate
System/Event/EmsEvent/EMBEDDEDANSIBLE/job_template_create
System/Event/EmsEvent/EMBEDDEDANSIBLE/job_template_delete
System/Event/EmsEvent/EMBEDDEDANSIBLE/project_update_associate
```

Although none are handled by default in the event switchboard, an event handler could be created if required to perform actions on receipt of such an event.



## Configuration

Embedded Ansible has a small customisation section in the **Configuration -> Advanced** settings list, as follows:

```
:embedded_ansible:
  :job_data_retention_days: 120
  :docker:
    :task_image_name: ansible/awx_task
    :task_image_tag: latest
    :web_image_name: ansible/awx_web
    :web_image_tag: latest
    :rabbitmq_image_name: rabbitmq
    :rabbitmq_image_tag: 3
    :memcached_image_name: memcached
    :memcached_image_tag: alpine
```

Although most settings would not need changing in normal operation, the `job_data_retention_days` value may need adjusting on a busy CFME or ManageIQ appliance. This determines the retention time in days that the playbook _.out_ files are kept for in _/var/lib/awx/job\_status_ (see Troubleshooting above). On a busy system running many verbose playbooks, the number of _.out_ files may consume significant space on the system disk, in which case the `job_data_retention_days` value should be reduced accordingly.

> **Note**
> 
> For embedded Ansible services the playbook output is shown in the **Provisioning** or **Retirement** tab of the service in the **Services -> My Services** page in the WebUI. This output is read directly from the corresponding job's _.out_ file, and so once the _*.out_ files are purged, the output is longer visible from the service details in the WebUI.

## Summary

