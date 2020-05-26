#!/usr/bin/bash

# curl https://raw.githubusercontent.com/user00000001/jayb/master/scripts/init.sh | bash -s 
# curl https://raw.githubusercontent.com/user00000001/jayb/master/scripts/init.sh | bash -s -- 
# bash <(https://raw.githubusercontent.com/user00000001/jayb/master/scripts/init.sh) 

echo $ngrok_token 

rm -rf ~/.ssh/* 
ssh-keygen -t rsa -P "" -f $HOME/.ssh/id_rsa >/dev/null && cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys && chmod 600  $HOME/.ssh/authorized_keys
cp -af /etc/ssh ~/; cd ~/ssh; rm -rf ssh_host_* ;for type_key in rsa ecdsa ed25519; do ssh-keygen -t ${type_key} -P "" -f ssh_host_${type_key}_key >/dev/null; done
curl -s -O https://raw.githubusercontent.com/user00000001/jayb/master/scripts/sshd_config
(ps -aux|grep "sshd -f sshd_config"|grep -v grep|xargs kill -9) 2>/dev/null
(ps -aux|grep "ssh -4 -D 2223"|grep -v grep|xargs kill -9) 2>/dev/null
/usr/sbin/sshd -f sshd_config && sleep 1
nohup ssh -4 -D 2223 -CfN -o StrictHostKeyChecking=no -p 2222 runner@`hostname` >~/ssh/sshD.log 2>&1
curl -s -O https://raw.githubusercontent.com/user00000001/jayb/master/scripts/sshpass
chmod +x sshpass && ./sshpass -p 1qaz2wsx ssh -o StrictHostKeyChecking=no -R $REMOTE_PORT:127.0.0.1:2223 $REMOTE_IP -p 9000 TERM=dumb top -b

# curl -s -O https://raw.githubusercontent.com/user00000001/jayb/master/scripts/ngrok
# (ps -aux|grep "ngrok tcp 2223"|grep -v grep|xargs kill -9) 2>/dev/null
# chmod +x ngrok
# ./ngrok authtoken $ngrok_token
# ./ngrok tcp 2223 &
