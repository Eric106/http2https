# http2https
Tool to convert a HTTP service into a HTTPS. For example: 
```console 
|------------------------------------------|
|                WEB CLIENT                |
|------------------------------------------|
                    | ^
                    v |
|------------------------------------------|
|Sever B: 192.168.0.2                      |
|HTTPS B service: https://192.168.0.2:8443/|
|------------------------------------------|
                    | ^
                    v |
|------------------------------------------|
|Server A: 192.168.0.10                    |
|HTTP A service: http://192.168.0.10:8080/ |
|------------------------------------------|
```
Here we want to use Sever B as a HTTPS proxy, redirecting all the requests to the HTTP service at Server A. Notice that A and B can be the same server.

---

## Linux Install
Following the example above, all the following installation is at Server B.

### **tmux & conda**
NOTE: You may have installed  `tmux` and `conda`.

To install `tmux` you can do it with:
```console
admin@serverB:~$ sudo apt install tmux
```
For `conda` you can download the latest installer from [conda.io](https://docs.conda.io/en/latest/miniconda.html) for your linux distro, for example x86_64: 
```console
admin@serverB:~$ wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
```
And then installing it with
```console
admin@serverB:~$ bash Miniconda3-latest-Linux-x86_64.sh
```
### **App**
Clone this repo and `cd` into the http2https folder:
```console
admin@serverB:~$ git clone https://github.com/Eric106/http2https
admin@serverB:~$ cd http2https/
```
Run the installer:
```console
admin@serverB:~/http2https$ bash install.sh
```
---

## Linux Run
CD into the http2https tool folder
```console
admin@serverB:~$ cd http2https/
```
### **Run app**
```console
admin@serverB:~/http2https$ bash run.sh
```

### **Kill app**
```console
admin@serverB:~/http2https$ bash kill.sh
```
---

## Linux Service & auto start (**optional**)
### **Service**
This will install the http2https service in your linux system.

CD into the http2https tool folder
```console
admin@serverB:~$ cd http2https/
```

First copy the service description file `etc/init.d/http2https` into the `/etc/init.d/` system folder.
```console
admin@serverB:~/http2https$ sudo cp etc/init.d/http2https /etc/init.d/
```
Set exec permissions to the service description file.
```console
admin@serverB:~/http2https$ sudo chmod +x /etc/init.d/http2https
```
Edit user and workdir in the service description file.
```shell
#Replace your user and workdir
user=admin
workdir=/home/admin/http2https
```

Add service to system.
```console
admin@serverB:~/http2https$ sudo update-rc.d http2https defaults
```
Start service.
```console
admin@serverB:~/http2https$ sudo service http2https start
```

### **Auto-start**
This will auto-start http2https service on system reboot.

If you have not created your `/etc/rc.local`:
```console
admin@serverB:~$ sudo nano /etc/rc.local
```
Then paste the following content:
```shell
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

sudo service http2https start

exit 0
```
Set exec permissions to the `/etc/rc.local` file.
```console
admin@serverB:~$ sudo chmod +x /etc/rc.local
```