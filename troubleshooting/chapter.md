# Troubleshooting

```
TASK [syncrou.manageiq-automate : Initialize the Workspace] ********************
An exception occurred during task execution. To see the full traceback, use -vvv. The error was: AttributeError: 'NoneType' object has no attribute 'read'
fatal: [localhost]: FAILED! => {"changed": false, "failed": true, "module_stderr": "Traceback (most recent call last):\n  File \"/tmp/ansible_xVSkWs/ansible_module_manageiq_automate.py\", line 510, in <module>\n    main()\n  File \"/tmp/ansible_xVSkWs/ansible_module_manageiq_automate.py\", line 502, in main\n    result = getattr(workspace, key)(value)\n  File \"/tmp/ansible_xVSkWs/ansible_module_manageiq_automate.py\", line 408, in initialize_workspace\n    workspace = self.get()\n  File \"/tmp/ansible_xVSkWs/ansible_module_manageiq_automate.py\", line 92, in get\n    return json.loads(result.read())\nAttributeError: 'NoneType' object has no attribute 'read'\n", "module_stdout": "", "msg": "MODULE FAILURE", "rc": 0}
```

Can be: Max TTL too short


## Summary


## Further Reading