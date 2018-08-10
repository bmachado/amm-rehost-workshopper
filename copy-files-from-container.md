# Copy files from container

As you recall from the last step, we can use `oc rsh` to execute commands inside the running pod.  
  
For our Coolstore Monolith running with JBoss EAP, the application is installed in the `/opt/eap` directory in the running container. Execute the `ls` command inside the container to see this:

```bash
oc  rsh dc/coolstore ls -l /opt/eap
```

You should see a listing of files in this directory **in the running container**.  
  
It is very important to remember where commands are executed! If you think you are in a container and in fact are on some other machine, destructive commands may do real harm, so be careful! In general it is not a good idea to operate inside immutable containers outside of the development environment. But for doing testing and debugging it's OK.  
  
Let's copy some files out of the running container. To copy files from a running container on OpenShift, we'll use the `oc rsync` command. This command expects the name of the pod to copy from, which can be seen with this command:  


```bash
oc get pods --selector deploymentconfig=coolstore
```

The output should show you the name of the pod:  
  
  


| NAME | READY | STATUS | RESTARTS | AGE |
| :--- | :--- | :--- | :--- | :--- |
| Coolstore-2-bpkkc | 1/1 | Running | 0 | 32m |

The name of my running coolstore monolith pod is **coolstore-2-bpkkc** but **yours will be different**.  
  
Save the name of the pod into an environment variable called **COOLSTORE\_DEV\_POD\_NAME** so that we can use it for future

Commands:  


```bash
export COOLSTORE_DEV_POD_NAME=$(oc get pods --selector deploymentconfig=coolstore -o jsonpath='{.items[?(@.status.phase=="Running")].metadata.name}')
```

Verify the variable holds the name of your pod with:

```bash
echo $COOLSTORE_DEV_POD_NAME
```

Next, run the oc rsync command in your terminal window, using the new variable to refer to the name of the pod running our coolstore:

```bash
oc  rsync $COOLSTORE_DEV_POD_NAME:/opt/eap/version.txt .
```

The output will show that the file was downloaded:

receiving incremental file list version.txt

sent 30 bytes received 65 bytes 62,566.00 bytes/sec total size is 65 speedup is 1.00

  
Now you can open the file locally using the command below and inspect its contents.

```bash
cat version.txt
```

This is useful for verifying that the contents of files in your applications are what you expect.

