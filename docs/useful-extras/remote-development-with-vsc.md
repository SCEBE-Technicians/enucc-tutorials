# Remote Development with Visual Studio Code

[This page](https://code.visualstudio.com/docs/remote/ssh) is generally an excellent guide to using visual studio code for remote development.

The only thing you'll need to configure is a proxy jump when accessing ENUCC from outside the university network.

Edit the file `%homepath%\.ssh\config` on windows or `~/.ssh/config` on unix systems, and add the following:

```
Host ext.login.enucc
    HostName login.enucc.napier.ac.uk
    User 40019142
    ProxyCommand ssh -W %h:%p 40019142@gateway.napier.ac.uk
```

You can then ssh to the host `ext.login.enucc` and you will jump through the gateway.
