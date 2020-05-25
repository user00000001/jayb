# Usage

## commands

```shell
# sudo apt install miniupnpc -y
# upnpc -a 192.168.0.50 22 9000 TCP
# upnpc -l 
# upnpc -d 9000 TCP
export ngrok_token=xxx ; curl https://raw.githubusercontent.com/user00000001/jayb/master/scripts/init.sh | bash && ssh -o StrictHostKeyChecking=no -R 8880:127.0.0.1:2223 xxxx -p 9000
```