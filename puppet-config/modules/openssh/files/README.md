This test root key pair is generated with the following command:

```
# ssh-keygen -f ./id_rsa_root
Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in ./id_rsa_root.
Your public key has been saved in ./id_rsa_root.pub.
The key fingerprint is:
32:c1:8b:13:a3:21:1e:92:f2:8e:2d:37:9a:3d:bc:23 root@thadmin1
The key's randomart image is:
+---[RSA 2048]----+
|                 |
| .   .           |
|=.. o o          |
|+o.o + o         |
| .o o + S        |
| +   . o         |
|o.=              |
|E*+.             |
|o.o+             |
+-----------------+
```

The private key is encrypted with the passphrase: '`password`'.

On a working cluster, you can use "clara enc" to encrypt and decrypt key files. If you only have openssl:

To encrypt:

```
# openssl aes-256-cbc -in id_rsa_root -out id_rsa_root.enc -k password
```

Example test host keys, are generated the same way.

Public keys are here for reference are here for reference but are not actually used since they
are dynamically regenerated when the private key is pulled.

