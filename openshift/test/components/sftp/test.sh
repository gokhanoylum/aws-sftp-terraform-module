#!/bin/bash
oc run netshoot-test --image=nicolaka/netshoot -it --rm -- /bin/bash

netshoot-test:~# sftp sftp_user@10.121.0.106
The authenticity of host '10.121.0.106 (10.121.0.106)' can't be established.
ED25519 key fingerprint is: SHA256:Xb0nmpo4vQz6cXqe4FKxSh83DKiSDlDnmKgAhZPI2I0
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.121.0.106' (ED25519) to the list of known hosts.
sftp_user@10.121.0.106's password:
Connected to 10.121.0.106.
sftp>