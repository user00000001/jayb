#!/usr/bin/bash

# curl https://raw.githubusercontent.com/user00000001/jayb/master/scripts/init.sh | bash

rm -rf ~/.ssh/* 
ssh-keygen -t rsa -P "" -f $HOME/.ssh/id_rsa && cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys && chmod 600  $HOME/.ssh/authorized_keys
cp -af /etc/ssh ~/; cd ~/ssh; rm -rf ssh_host_*.pub ;for type_key in rsa ecdsa ed25519; do ssh-keygen -t ${type_key} -P "" -f ssh_host_${type_key}_key; done
curl -O https://raw.githubusercontent.com/user00000001/jayb/master/scripts/sshd_config
/usr/sbin/sshd -f sshd_config
ssh -D 2223 runner@`hostname`

mkdir ~/.ngrok2/ && cd ~/.ngrok2/
curl -O https://raw.githubusercontent.com/user00000001/jayb/master/scripts/ngrok.yml
curl -O https://raw.githubusercontent.com/user00000001/jayb/master/scripts/ngrok
chmod +x ngrok && ./ngrok tcp 2223 
