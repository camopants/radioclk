To create a service under systemd easily requires a process to run in foreground, in a systemd wrapper.  Before attempting to create the service, address any SELinux issues (notes elsewhere in this repo).



```
systemctl status radioclkd
```

should result in a response similar to

```
● radioclkd.service - Start radio clock daemon
     Loaded: loaded (/etc/systemd/system/radioclkd.service; enabled; preset: disabled)
     Active: active (running) since Tue 2025-07-15 01:06:16 BST; 1 week 3 days ago
    Process: 945 ExecStartPre=/bin/mkdir -p /run/radioclkd (code=exited, status=0/SUCCESS)
    Process: 962 ExecStartPre=/bin/chmod -R 755 /run/radioclkd (code=exited, status=0/SUCCESS)
    Process: 965 ExecStart=/usr/local/sbin/radioclkd ${DEVICE} (code=exited, status=0/SUCCESS)
   Main PID: 968 (radioclkd)
      Tasks: 1 (limit: 48393)
     Memory: 740.0K
        CPU: 3min 11.001s
     CGroup: /system.slice/radioclkd.service
             └─968 /usr/local/sbin/radioclkd ttyS0
```
