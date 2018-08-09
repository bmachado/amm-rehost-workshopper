# Configuring JBoss Developer Studio with the application

You can also control the JBoss EAP runtime with JBoss Developer Studio by following the steps below.

Before starting, we will need to undeploy the application. In the terminal window, run the following commands:

```bash
cd ~/projects/monolith
mvn wildfly:start wildfly:undeploy wildfly:shutdown
```

Add the server installed in the previous step in the server tab by right clicking in the blank space, navigating on **new → Server**.

![](../images/scenario1/image42.png)

Select Red Hat JBoss Enterprise Application Platform 7.1 as the server type and click Next.

![](../images/scenario1/image58.png)

Click Next again. Browse to JBoss EAP 7 installation directory `/home/developer/jboss-eap-7.1`, select standalone-full.xml in the configuration file and click next.

![](../images/scenario1/image21.png)

Choose monolith\(ROOT\) application, click add button and finish.

![](../images/scenario1/image44.png)

Click in the Start button to run EAP instance.

![](../images/scenario1/image18.png)

Check if EAP has started successfully in the console

![](../images/scenario1/image2.png)

Check again the coolstore application in the web browser accessing

`http://localhost:8080`

Then, click in the stop button to shutdown JBoss EAP.

![](../images/scenario1/image1.png)

