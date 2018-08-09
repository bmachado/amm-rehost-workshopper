# Deploy the monolith to OpenShift

We now have a fully migrated application that we tested locally. Let's deploy it to OpenShift.

1. Add a OpenShift profile

Open the `pom.xml` file.

At the `<!-- TODO: Add OpenShift profile here -->` we are going to add a the following configuration to the pom.xml

```markup
<profile>
  <id>openshift</id>
  <build>
      <plugins>
          <plugin>
              <artifactId>maven-war-plugin</artifactId>
              <version>2.6</version>
              <configuration>
                  <webResources>
                      <resource>
                          <directory>${basedir}/src/main/webapp/WEB-INF</directory>
                          <filtering>true</filtering>
                          <targetPath>WEB-INF</targetPath>
                      </resource>
                  </webResources>
                  <outputDirectory>deployments</outputDirectory>
                  <warName>ROOT</warName>
              </configuration>
          </plugin>
      </plugins>
  </build>
</profile>
```

2. Create the OpenShift project

First, open the OpenShift Console in the browser:

`https://master.[EVENT-NAME].openshiftworkshop.com`

![OpenShift Console](../images/scenario1/image28.png)

Login using:

* Username: `user[YOUR-USER-NUMBER]`
* Password: `openshift`

You will see the OpenShift landing page:

![OpenShift Console](../images/scenario1/image62.png)

Click Create Project, fill in the fields, and click Create:

* Name: `coolstore-dev`
* Display Name: `Coolstore Monolith - Dev`
* Description: _leave this field empty_

NOTE: Replace \[your-username\] with your login in openshift. \[your-username\] before coolstore-dev is required since all students are using the same openshift cluster and it doesn't allow to have more than one project with the same project name.

NOTE: YOU MUST USE `coolstore-dev` AS THE PROJECT NAME, as this name is referenced later on and you will experience failures if you do not name it `coolstore-dev`!

![OpenShift Console](../images/scenario1/image25.png)

Click on the name of the newly-created project:

![OpenShift Console](../images/scenario1/image6.png)

This will take you to the project overview. There's nothing there yet, but that's about to change.

3. Deploy the monolith

We'll use the CLI to deploy the components for our monolith. To deploy the monolith template using the CLI, execute the following commands:

Firstly, you will need to open the terminal window and make a login into Openshift Container Platform. The web interface provides a ready to use oc command with the token needed.

![](../images/scenario1/image30.png)

Just paste it in the terminal window:

```bash
oc login https://master.[EVENT-NAME].openshiftworkshop.com --token=apslfkwikdk
```

Switch to the terminal window in project you created earlier:

```bash
oc project coolstore-dev
```

And finally deploy template:

```bash
oc new-app coolstore-monolith-binary-build
```

This will deploy both a PostgreSQL database and JBoss EAP, but it will not start a build for our application.

Then open up the Monolith Overview page at

`https://master.[EVENT-NAME].openshiftworkshop.com/console/project/coolstore-dev/` and verify the monolith template items are created:

![OpenShift Console](../images/scenario1/image16.png)

You can see the components being deployed on the Project Overview, but notice the No deployments for Coolstore. You have not yet deployed the container image built in previous steps, but you'll do that next.

4. Deploy application using Binary build

In this development project we have selected to use a process called binary builds, which means that we are going to build locally and just upload the artifact \(e.g. the .war file\). The binary deployment will speed up the build process significantly.

First, build the project once more using the openshift Maven profile, which will create a suitable binary for use with OpenShift \(this is not a container image yet, but just the .war file\). We will do this with the oc command line.

Build the project:

Using JBoss Developer studio, right click in the pom.xml, navigate to **Run As → Maven build…**  
  


![](../images/scenario1/image59.png)

Add clean package -Popenshift as the goals to this maven build

![](../images/scenario1/image57.png)

You can also run the command below in the terminal window if you prefer

```bash
mvn clean package -Popenshift
```

Wait for the build to finish and the `BUILD SUCCESS` message!

Go to Openshift Explorer tab and add a new connection using its wizard:

![](../images/scenario1/image46.png)

Enter the master node url provided by the instructor \([https://master.\[EVENT-NAME\].openshiftworkshop.com](about:blank)\), select Basic protocol and enter with your userN and password openshift.

![](../images/scenario1/image10.png)

Accept the SSL certificate.

![](../images/scenario1/image7.png)

Then click finish.

You will see the Openshift connection in Openshift Explorer tab.

![](../images/scenario1/image54.png)

And finally, start the build process that will take the `.war` file and combine it with JBoss EAP and produce a Linux container image which will be automatically deployed into the project, thanks to the _DeploymentConfig_ object created from the template.

In terminal window, certify you are in the coolstore-dev project

```bash
oc get project
```

Start the coolstore application build

```bash
oc start-build coolstore --from-file=${HOME}/projects/monolith/deployments/ROOT.war
```

![](../images/scenario1/image34.png)

Check the OpenShift web console and you'll see the application being built:

![OpenShift Console](../images/scenario1/image39.png)

You will also see the Openshift Explorer tab in JBoss Developer Studio updated.

![](../images/scenario1/image37.png)

In terminal window, wait for the build and deploy to complete:

```bash
oc rollout status -w dc/coolstore
```

This command will be used often to wait for deployments to complete. Be sure it returns success when you use it! You should eventually see replication controller "coolstore-1" successfully rolled out.

If the above command reports `Error from server`\(ServerTimeout\) then simply re-run the command until it reports success!

When it's done you should see the application deployed successfully with blue circles for the database and the monolith:

![OpenShift Console](../images/scenario1/image38.png)

Test the application by clicking on the Route link at

`http://www.coolstore-dev.[EVENT-NAME].openshiftworkshop.com` , which will open the same monolith Coolstore in your browser, this time running on OpenShift:

![OpenShift Console](../images/scenario1/image53.png)



