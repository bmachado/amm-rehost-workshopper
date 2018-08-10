# Turn on Live Sync

Turn on Live sync by executing this command:

```bash
oc  rsync ${HOME}/projects/monolith/deployments/ $COOLSTORE_DEV_POD_NAME:/deployments --watch --no-perms &
```

The `&` character at the end places the command into the background. We will kill it at the end of this step.  
  
Now oc is watching the deployments directory for changes to the ROOT.war file. Anytime that file changes, oc will copy it into the running container and we should see the changes immediately \(or after a few seconds\). This is much faster than waiting for a full re-build and re-deploy of the container image.

