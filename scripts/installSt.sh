
export setupEnv="$"
export srDir="~/apps/supertokens-root"

installJDK() {
  ## if java is not installed then install it
  if java --version | grep -q "openjdk 15.0.1"; then
    echo "found java"
    return 1
  else
    echo "Java Not found. installing..."
  fi
  
  sudo mkdir -p /usr/java
  cd /usr/java

  if test -e "openjdk-15.0.1_linux-x64_bin.tar.gz"; then
    echo "jdk already exists"
  else
    sudo wget https://download.java.net/java/GA/jdk15.0.1/51f4f36ad4ef43e39d0dfdbaf6549e32/9/GPL/openjdk-15.0.1_linux-x64_bin.tar.gz
  fi
  
  if [ -d "/usr/java/jdk-15.0.1" ]
  then 
    echo "jdk already exists"
  else
    sudo tar -xzvf openjdk-15.0.1_linux-x64_bin.tar.gz
    env JAVA_HOME=/usr/java/jdk-15.0.1 &&
    env PATH=$PATH:$HOME/bin:$JAVA_HOME/bin &&
    env JRE_HOME 
    echo "export JAVA_HOME=/usr/java/jdk-15.0.1" >> ~/.bashrc
    echo "export PATH=$PATH:$HOME/bin:$JAVA_HOME/bin"  >> ~/.bashrc
    echo "export JRE_HOME" >> ~/.bashrc
  fi

  
  echo "java installed"
  if java --version; then
    echo "found java"
    java --version
    return 1
  else
    echo "Java could not be installed"
    exit 0
  fi
}

cloneSupertokensRoot() {
  ## if apps folder doesn't exist then create it and clone the repo
  if [ -d "~/apps" ] && [ -d srDir ]
  then
    # then take pull from latest branch
    cd $srDir
    git pull
  else
    if [ -d "~/apps" ]
    then 
      echo "~/apps already exists"
    else
      mkdir ~/apps
    fi
    cd ~/apps
    git clone git@github.com:nilinswap/supertokens-root.git
  fi
  cd ~/apps
}


installSupertokens() {
    sudo apt-get update
    sudo apt-get install screen
    cd ~/apps/supertokens-root
    ./loadmodules
}

foreignMain() {
  cloneSupertokensRoot
  installJDK
  installSupertokens
}

foreignMain