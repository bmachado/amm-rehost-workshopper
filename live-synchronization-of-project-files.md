# Live Synchronization of Project Files

In addition to being able to manually upload or download files when you choose to, the `oc rsync` command can also be set up to perform live synchronization of files between your local computer and the container. When there is a change to a file, the changed file will be automatically copied up to the container.  
  
This same process can also be run in the opposite direction if required, with changes made in the container being automatically copied back to your local computer.  
  
An example of where it can be useful to have changes automatically copied from your local computer into the container is during the development of an application.  
  
For scripted programming languages such as JavaScript, PHP, Python or Ruby, where no separate compilation phase is required you can perform live code development with your application running inside of OpenShift.  
  
For JBoss EAP applications you can sync individual files \(such as HTML/CSS/JS files\), or sync entire application .WAR files. It's more challenging to synchronize individual files as it requires that you use an **exploded** archive deployment, so the use of [JBoss Developer Studio](https://developers.redhat.com/products/devstudio/overview/) is recommended, which automates this process \(see these [docs](https://tools.jboss.org/features/livereload.html) for more info\). We are going to explore JBoss Developer Studio plugins later in this workshop.

