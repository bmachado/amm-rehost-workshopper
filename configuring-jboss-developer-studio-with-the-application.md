# Configuring JBoss Developer Studio with the application

You can also control the JBoss EAP runtime with JBoss Developer Studio by following the steps below.

Before starting, we will need to undeploy the application. In the terminal window, run the following commands:

~~~shell
cd ~/projects/monolith
mvn wildfly:start wildfly:undeploy wildfly:shutdown
~~~

Add the server installed in the previous step in the server tab by right clicking in the blank space, navigating on **new → Server**.

![]({% image_path /scenario1/image42.png %}){:width="650 px"}

Select Red Hat JBoss Enterprise Application Platform 7.1 as the server type and click Next.

![]({% image_path /scenario1/image58.png %}){:width="650 px"}

Click Next again. Browse to JBoss EAP 7 installation directory `/home/developer/jboss-eap-7.1`, select standalone-full.xml in the configuration file and click next.

![]({% image_path /scenario1/image21.png %}){:width="650 px"}

Choose monolith\(ROOT\) application, click add button and finish.

![]({% image_path /scenario1/image44.png %}){:width="650 px"}

Click in the Start button to run EAP instance.

![]({% image_path /scenario1/image18.png %}){:width="650 px"}

Check if EAP has started successfully in the console

![]({% image_path /scenario1/image2.png %}){:width="650 px"}

Check again the coolstore application in the web browser accessing

`http://localhost:8080`

Then, click in the stop button to shutdown JBoss EAP.

![]({% image_path /scenario1/image1.png %}){:width="650 px"}

