To create a service under systemd first address any SELinux issues (notes el
sewhere in this repo).  Once the program starts manually 



## Creating the systemd service
The following instructions assume that the daemon binary is installed at *<p
re>/usr/local/sbin/radioclkd</pre>*.  (Why would you install it anywhere els
e?)  If this is not the case, then the service file will need to be altered 
accordingly.

### Create the service definition
Copy the service definition file into systemd's service catalogue, and set o
wnership/permissions appropriately
```
sudo cp radioclkd.service /etc/systemd/system/
sudo chown root:root /etc/systemd/system/radioclkd.service
sudo chmod 644 /etc/systemd/system/radioclkd.service
```
Refresh systemd's index of the service catalogue
```
sudo systemctl daemon-reload
```

### Starting and stopping the daemon
Starting the radioclkd daemon should now be as simple as
```
sudo systemctl start radioclkd
```
And to stop
```
sudo systemctl stop radioclkd
```

### Testing
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

### Persistence
To enable automatic starting of the daemon at boot time
```
systemctl start radioclkd.service
```

### Caveat
As it currently stands, the radio clock daemon is invoked by systemd as root, 
and continues to run that way, without dropping privileges.
