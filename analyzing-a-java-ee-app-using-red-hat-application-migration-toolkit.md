# Analyzing a Java EE app using Red Hat Application Migration Toolkit

For this scenario, we will use the CLI and Eclipse Plugin as you are the only one that will run RHAMT in this system. For multi-user use, the Web Console would be a good option.

1. Verify Red Hat Application Migration Toolkit CLI

   The RHAMT CLI is has been installed for you. To verify that the tool was properly installed, open a terminal window navigating on Application → System Tools → Terminal and run the following command:

```bash
${HOME}/rhamt-cli-4.0.1.Final/bin/rhamt-cli --version
```

You should see:

```bash
Using RHAMT at /root/rhamt-cli-4.0.1.Final
> Red Hat Application Migration Toolkit (RHAMT) CLI, version 4.0.1.Final.
```

2. Run the RHAMT CLI against the project

This is a minimal Java EE project which uses [JAX-RS](https://docs.oracle.com/javaee/7/tutorial/jaxrs.htm) for building RESTful services and the [Java Persistence API \(JPA\)](https://docs.oracle.com/javaee/7/tutorial/partpersist.htm) for connecting to a database and an [AngularJS](https://angularjs.org/) frontend.

When you later deploy the application, it will look like:

![CoolStore Monolith]({% image_path /scenario1/image27.png %})

The RHAMT CLI has a number of options to control how it runs. Click on the below command to execute the RHAMT CLI and analyze the existing project:

```bash
~/rhamt-cli-4.0.1.Final/bin/rhamt-cli \
  --sourceMode \
  --input ~/projects/monolith \
  --output ~/rhamt-reports/monolith \
  --overwrite \
  --source weblogic \
  --target eap:7 \
  --packages com.redhat weblogic
```

Note the use of the --source and --target options. This allows you to target specific migration paths supported by RHMAT. Other migration paths include IBM® WebSphere® Application Server and JBoss EAP 5/6/7.

Wait for it to complete before continuing!. You should see Report created in:

```bash
/home/developer/rhamt-reports/monolith/index.html
```

3. View the results

Next, open the following file `/home/developer/rhamt-reports/monolith/index.html` in your browser. You should see the landing page for the report:

=======
![Landing Page]({% image_path /scenario1/image19.png %})

The main landing page of the report lists the applications that were processed. Each row contains a high-level overview of the story points, number of incidents, and technologies encountered in that application.Click on the **monolith** link to access details for the project:

![Project Overview]({% image_path /scenario1/image52.png %})

Now that you have the RHAMT report available, let's get to work migrating the app!  


