# Migrate Application Startup Code

In this step we will migrate some Weblogic-specific code in the app to use standard Java EE interfaces.

Follow these steps to use the Eclipse plugin to identify and resolve migration issues.

1. Import the monolith project \(`~/projects/monolith`\) to analyze into JBoss Developer Studio. Navigate to **File → Import → Existing Maven Projects → Next**

![]({% image_path /scenario1/image4.png %})

2. Browse to `/home/developer/projects/monolith` and click on Finish button

![]({% image_path /scenario1/image23.png %})

3. Create a run configuration. From the Issue Explorer, press the RHAMT button \( ![RHAMT button]({% image_path /scenario1/image43.png %}) \).

![Select RHAMT button]({% image_path /scenario1/image49.png %})

4. Add the monolith project to RHAMT configuration

![]({% image_path /scenario1/image14.png %})

5. Click Run to execute **RHAMT**.

6. Wait until the analysis reports are generated

![]({% image_path /scenario1/image60.png %})

