![iRedMail logo](assets/iredmail_410x280.png )
# iRedMail-0.9.9 Deployer

[![HitCount](http://hits.dwyl.io/lnfel/lnfel/iredmail099_deployer.svg)](http://hits.dwyl.io/lnfel/lnfel/iredmail099_deployer)

Use this shell script to deploy iRedMail to multiple domains!

## Installation

Clone this repo to any server you want to serve as host for the iRedMail repo

```console
user@servername:~# git clone https://github.com/lnfel/iredmail.0.9.9_deployer.git
```

or download the repo and transfer it to your server in anyway you want.

## How to use?

Not familiar with shell script? Here's how to get started:

1. Once you have the iredmail.0.9.9_deployer folder on your server, **cd into the folder**:

```console
user@servername:~# cd iredmail.0.9.9_deployer
```

2. **Change user permissions** on the following files using **chmod 755**:

- install.sh
- multi-deploy.sh
- test.sh
- args

Ex.

```console
root@sushipunch:~/iredmail.0.9.9_deployer# chmod 755 multi-deploy.sh
```

3. **Modify args file** using a text editor. If you are on linux use vim:

```console
root@sushipunch:~/iredmail.0.9.9_deployer# vi args
```

you should see the sample domains:

```
sushipunch.tk
flashraven.tk
facebook.com
google.com
```

Simply remove the domains and replace it with your target domains

- Press "i" to enter edit mode
- Press "escape" to exit edit mode
- Press "shift+:" (shift+colon) so we can enter a vim command
- Enter "w" to save the file or "q" to quit without saving
- Enter "wq" to save the file and quit the editor

## Test your domains

To run test.sh enter the following command on your terminal:

```console
root@sushipunch:~/iredmail.0.9.9_deployer# ./test.sh "$(< args)"
```

This should iterate through args file and ping all domains you have.
