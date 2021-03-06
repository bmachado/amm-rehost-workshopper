# Migrate and run the project

Now that we migrated the application you are probably eager to test it. To test it we locally we first need to install JBoss EAP.

Open a terminal window by clicking on **Applications → System Tools → Terminal**

Run the following command in the terminal window.

~~~shell
unzip -d $HOME $HOME/Downloads/jboss-eap-7.1.0.zip
~~~

We should also set the **JBOSS\_HOME** environment variable like this:

~~~shell
export JBOSS_HOME=$HOME/jboss-eap-7.1
~~~

Done! That is how easy it is to install JBoss EAP.

Return to JBoss Developer Studio and change the perspective to JBoss by clicking in the icon ![]({% image_path /scenario1/image36.png %}){:width="137.06666666666666 px"} or navigating on **Window → Perspective → Open Perspective → Other → JBoss**

Open the `pom.xml` file, and click in pom.xml tab.

![]({% image_path /scenario1/image26.png %}){:width="449.4666666666667 px"}



