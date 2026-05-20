# Generating an SSH Key Pair

## Linux

Generate a new SSH key pair:

```bash
ssh-keygen -t rsa -C "Optional comment e.g. HPC key"
```

Example:

```text
a_hallard@scebe-gpu-server:~$ ssh-keygen -t rsa -C "HPC key"
Generating public/private rsa key pair.
Enter file in which to save the key (/home/a_hallard/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/a_hallard/.ssh/id_rsa
Your public key has been saved in /home/a_hallard/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:vZJ79gZe+SB0Drnx3xyYZ75qmu9asB4aLljj5xq90Wc HPC key
The key's randomart image is:
+------[RSA]------+
|                 |
|                 |
|           .     |
|         .= .    |
|        S..O .o  |
|       o..=.Oo + |
|      +.+=.B E+o.|
|     . oo+X B.o.o|
|       .*B BB+...|
+----[SHA256]-----+
a_hallard@scebe-gpu-server:~$
```

The SSH key pair will be stored in:

```
/home/<username>/.ssh/
```

Typically:

* Private key:

    ```
    ~/.ssh/id_rsa
    ```

* Public key:

    ```
    ~/.ssh/id_rsa.pub
    ```

To display the public key:

```bash
cat ~/.ssh/id_rsa.pub
```

---

## Windows

Open PowerShell and run:

```powershell
ssh-keygen -t rsa -C "Optional comment e.g. HPC key"
```

Example:

```powershell
PS C:\Users\Alex> ssh-keygen -t rsa -C "HPC key"
Generating public/private rsa key pair.
Enter file in which to save the key (C:\Users\Alex/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in C:\Users\Alex\.ssh\id_rsa
Your public key has been saved in C:\Users\Alex\.ssh\id_rsa.pub
```

The SSH key pair will usually be stored in:

```text
C:\Users\<username>\.ssh\
```

To display the public key:


```powershell
Get-Content $env:USERPROFILE\.ssh\id_rsa.pub
```


---

## macOS

Open the Terminal application and run:

```bash
ssh-keygen -t rsa -C "Optional comment e.g. HPC key"
```

Example:

```text
alex@MacBook-Pro ~ % ssh-keygen -t rsa -C "HPC key"
Generating public/private rsa key pair.
Enter file in which to save the key (/Users/alex/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /Users/alex/.ssh/id_rsa
Your public key has been saved in /Users/alex/.ssh/id_rsa.pub
```

The SSH key pair will usually be stored in:

```text
/Users/<username>/.ssh/
```

To display the public key:

```bash
cat ~/.ssh/id_rsa.pub
```

---

## Copying the Public Key

You normally copy the contents of the `.pub` file to the remote server or service.

If using linux you can use `ssh-copy-id [server]` that will complete the public key transfer for you.

Example public key:

```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQ... HPC key
```

!!! warning 
    
    #### Never share the private key
    ```
    id_rsa
    ```

    Only share:

    ```
    id_rsa.pub
    ```

    
To copy the public key:

- Login to the server
- Create/edit `.ssh/authorized_keys`
- Add the public key
