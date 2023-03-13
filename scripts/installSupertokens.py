import subprocess
import os
import shutil


### This is a failed attempt to run the startTestEnv script and then run the java command to start the server. I will attack this problem a little later. 


# Spawn a new process using subprocess
os.chdir('..')
process = subprocess.Popen(['./startTestEnv', '--wait'], stdout=subprocess.PIPE)

print("process id: ", process.pid)

# Print the output
for line in process.stdout:
    print(line.decode().strip())
    if (line.decode().strip() == 'Test environment started! Leave this script running while running tests.'):
        break

# do something else here
shutil.copyfile("./temp/config.yaml", "./config.yaml")


process2 = subprocess.Popen('java -classpath "./core/*:./plugin-interface/*:./ee/*" io.supertokens.Main ./ DEV'.split(' '), stdout=subprocess.PIPE)
for line in process2.stdout:
    print(line.decode().strip())
