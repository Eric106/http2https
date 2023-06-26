# http2https
Linux service that converts http to https. When you can't modify the original http service this tool comes around.  For example: 
```console 
|------------------------------------------|
|                WEB CLIENT                |
|------------------------------------------|
                    | ^
                    v |
|------------------------------------------|
|Sever B: 192.168.0.2     (http2https)     |
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

To install `tmux `, `jq` and `openssl` you can do it with:
```console
admin@serverB:~$ sudo apt install tmux jq openssl
```
For `conda` you can download the latest installer from [conda.io](https://docs.conda.io/en/latest/miniconda.html) for your linux distro, for example x86_64: 
```console
admin@serverB:~$ wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
```
And then installing it with
```console
admin@serverB:~$ bash Miniconda3-latest-Linux-x86_64.sh
```
When the installer prompt if you want to execute "conda init" select yes. Then to avoid the activation of the conda base environment use this:
```console
admin@serverB:~$ conda config --set auto_activate_base false
```
### **App**
Clone this repo. ***Note that where you clone the repo, it will be the installation folder. For example i will clone it in the /home directory of the user "admin", so if i don't set a custom bind name for the service, the installation folder will be /home/admin/http2https.*** 
```console
admin@serverB:~$ git clone https://github.com/Eric106/http2https
```
Then `cd` into the http2https folder:
```console
admin@serverB:~$ cd http2https/
```
Run the installer (your user need to have sudo access to install the linux service) :
```console
admin@serverB:~/http2https$ bash install.sh
```
This will install the conda environment called http2https, then the python packages needed will be installed. Then it will prompt you for input about the config of your service like : 

-`http server ip`

-`http port`

-`https port`

-`ssl cert & key`. You can select if you want to use a custom ssl cert and key paths or generate a self-signed key pair

-`bind name for the service` (default http2https). Note that if you change the bind name of the service it will change the name of the instalation folder, and linux service name.

---

## Linux run -> **Service**
After installation of the linux service you can start, stop and restart it with this simple commands. Assuming that you keep the default service bind name (http2https).

### **Run app**
```console
admin@serverB:~$ sudo service http2https start
```
### **Check app console**
```console
admin@serverB:~$ tmux a -t http2https
```
### **Kill app**
```console
admin@serverB:~$ sudo service http2https stop
```
### **Restart app**
```console
admin@serverB:~$ sudo service http2https restart
```
Note that for the installation of the service we have 2 important files:

- `/etc/init.d/http2https`  -> This is the description of the linux service tha name may will be different if you set a custom service bind name.

- `/etc/rc.local`-> This file set the service to start on server reboot/start.
---

## Uninstall service, auto-start and conda environment
You just need to cd into your installation folder 
```console
admin@serverB:~$ cd http2https/
```
And run the following command
```console
admin@serverB:~/http2https$ bash uninstall.sh
```