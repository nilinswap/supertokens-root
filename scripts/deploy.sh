#!/bin/bash

## take ec2 instance host address and ssh_key to use to login there and env to run it in as input
export host="$1"
export sshKey="$2"
export srDir="~/apps/supertokens-root"

## if there is ~/apps/supertokens-root then check if git can run. if it can, then take pull from latest branch
main() {
  scpLocalToRemote $sshKey $host
}

scpLocalToRemote() {
  ## This function will take the ssh key and the host address as input and scp the local ssh key to the remote host. This will be used to login to the github
  local key="$1"
  local hostname="$2"
  echo "hostname" $hostname
  scp -r -i "$key" ~/.ssh/remoteKeysSupertoken/id_rsa ubuntu@$hostname:~/.ssh/id_rsa && 
  scp -r -i "$key" ~/.ssh/remoteKeysSupertoken/id_rsa.pub ubuntu@$hostname:~/.ssh/id_rsa.pub &&
  scp -r -i "$key" installSt.sh ubuntu@$hostname:~/installSt.sh 

  ## I am assuming that the key files are stored here in ~/.ssh/remoteKeysSupertoken
  ## what if this gets lost? - just gen a new key (using ssh-keygen) and add it to github.

}



## then go download java if it is not there already. test exact version of java
## then run setup steps - use systemd service to launch both startTestEnv command and java -classpath "./core/:./plugin-interface/:./ee/*" io.supertokens.Main ./ DEV host=0.0.0.0
## if input is uat then run with mode dev but what about otherwise?



#### Going ahead we will add following
## - take "deploy" or "restart" as option.
## - take branch as input
main
