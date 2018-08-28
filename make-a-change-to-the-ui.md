# Make a change to the UI

Next, let's make a change to the app that will be obvious in the UI.  
  
**1.** Open `src/main/webapp/app/css/coolstore.css`, which contains the CSS stylesheet for the  
CoolStore app.  
  
Add the following CSS to turn the header bar background to Red Hat red. Copy it at the bottom of the file:

~~~css
.navbar-header {
    background: #CC0000
}
~~~

You can use the editor you prefere, in our case we are using JBoss Developer Studio.

![]({% image_path /scenario2/image43.png %}){:width="650 px"}
<br><br><br>


**2.** Rebuild application For RED background

Let's re-build the application using this command in the terminal window:

~~~shell
mvn package -Popenshift
~~~

Or you can also right click pom.xml, navigate to **Run As -&gt; Maven Build…**

![]({% image_path /scenario2/image7.png %}){:width="650 px"}
<br><br><br>
Add "**package -Popenshift**" in the goals field and click run

![]({% image_path /scenario2/image50.png %}){:width="650 px"}

This will update the ROOT.war file and cause the application to change.

Re-visit the app by reloading the Coolstore webpage [{{OPENSHIFT_COOLSTORE_DEV_URL}}]({{OPENSHIFT_COOLSTORE_DEV_URL}}){:target="_blank"}.

You should now see the red header:

> NOTE If you don't see the red header, you may need to do a full reload of the webpage. On Windows/Linux press `CTRL+F5` or hold down SHIFT and press the Reload button, or try `CTRL+SHIFT+F5`. On Mac OS X, press `SHIFT+CMD+R`, or hold SHIFT while pressing the Reload button.

![Red]({% image_path /scenario2/image5.png %}){:width="650 px"}
<br><br><br>
**3.** Rebuild again for BLUE background

Repeat the process, but replace the background color to be blue \(click Copy to Editor to replace `#CC0000` with `blue`\):

~~~css
background: blue
~~~

Or change it in the color palet
<br><br><br>
![]({% image_path /scenario2/image37.png %}){:width="250 px"}
<br><br><br>
![]({% image_path /scenario2/image24.png %}){:width="350 px"}

Again, re-build the app:

~~~shell
mvn package -Popenshift
~~~

Or

![]({% image_path /scenario2/image29.png %}){:width="250 px"}

This will update the ROOT.war file again and cause the application to change.
<br><br><br>
Re-visit the app by reloading the Coolstore webpage [{{OPENSHIFT_COOLSTORE_DEV_URL}}]({{OPENSHIFT_COOLSTORE_DEV_URL}}){:target="_blank"}

![Blue](../{% image_path /scenario2/image2.png %}){:width="650 px"}

It's blue! You can do this as many times as you wish, which is great for speedy development and testing.

We'll leave the blue header for the moment, but will change it back to the original color soon.

Because we used `oc rsync` to quickly re-deploy changes to the running pod, the changes will be lost if we restart the pod. Let's update the container image to contain our new blue header. Execute:

~~~shell
oc start-build coolstore --from-file=${HOME}/projects/monolith/deployments/ROOT.war
~~~

And again, wait for it to complete by executing:

~~~shell
oc rollout status -w dc/coolstore
~~~

Or follow it in the Openshift web console [{{OPENSHIFT_MASTER_URL}}/console]({{OPENSHIFT_MASTER_URL}}/console){:target="_blank"} by clicking in the coolstore project and expanding the application tab.

![](../{% image_path /scenario2/image18.png %}){:width="650 px"}

