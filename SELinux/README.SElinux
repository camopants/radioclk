**radioclkd** can be made to work within SELinux constraints, but will not 
do 
so out of the box.  The daemon binary is operating in the wrong context, 
and the context the NTP service itself runs under does not allow shared 
memory access.

The easy, but *wrong*, solution is simply to disable SELinux enforcement.  
The better way is to ensure the daemon operates in the correct context and 
an associated shared memory access policy allows both the clock daemon and 
the NTP service to interact with shared memory.

These notes - with included policies, perhaps - will demonstrate how.  Work 
yet to progress.



# Implementation
## Assumptions
Everything is predicated on the assumption that radioclkd is a part of the 
existing NTP SELinux context.

## Create correct context for the daemon executable
After compilation and installation installation, check the current SELinux 
context of the executable.
<pre>
$ ls -lZ `which radioclkd`
-rwxr-xr-x. 1 root root unconfined_u:object_r:bin_t:s0 24536 May 11 18:16 /usr/local/sbin/radioclkd
</pre>

The daemon executable is operating in the default context for an installed 
binary.

Now determine the context of the ntpd binary.
<pre>
$ ls -lZ `which ntpd`
-rwxr-xr-x. 1 root root system_u:object_r:ntpd_exec_t:s0 595408 Aug 22  2023 /usr/sbin/ntpd
</pre>

Apply the same to the clock daemon.
<pre>
$ sudo chcon system_u:object_r:ntpd_exec_t:s0 /usr/local/sbin/radioclkd
[sudo] password for ...

$ ls -lZ /usr/local/sbin/radioclkd
-rwxr-xr-x. 1 root root system_u:object_r:ntpd_exec_t:s0 24536 May 11 18:16 /usr/local/sbin/radioclkd
</pre>

## Policy installation
### create new
<pre>
n=ntp_shm_policy
vi ${n}.te
</pre>

<pre>
module ntp_shm_policy 1.0;

require {
		type unconfined_service_t;
		type ntpd_t;
		class shm { associate read write };
		class shm { unix_read unix_write };
}

#============= ntpd_t ==============

allow ntpd_t unconfined_service_t:shm associate;
allow ntpd_t unconfined_service_t:shm { read write };
allow ntpd_t unconfined_service_t:shm { unix_read unix_write };
</pre>

### compile and instate
<pre>
checkmodule -M -m -o ${n}.{mod,te} && \
  semodule_package -o ${n}.pp -m ${n}.mod && \
    sudo semodule -i ${n}.pp
</pre>
