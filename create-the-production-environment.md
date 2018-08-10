# Create the production environment

We will create and initialize the new production environment using another template in a separate OpenShift project.

1. Initialize production project environment

Execute the following oc command to create a new project:

```bash
oc new-project coolstore-prod --display-name='Coolstore Monolith - Production'
```

This will create a new OpenShift project called `coolstore-prod` from which our production application will run.

You can also create the project using JBoss Developer Studio or Openshift Web Console if you prefer.

Right click in the Openshift connection, go to **New -&gt; Project**

![](../images/scenario2/image36.png)

Add the same project info in the fields

![](../images/scenario2/image31.png)

2. Add the production elements

In this case we'll use the production template to create the objects. Execute:

```bash
oc new-app --template=coolstore-monolith-pipeline-build
```

Or right click in the new Production **coolstore-prod -&gt; New -&gt; Application**

![](../images/scenario2/image16.png)

Choose the monolith project and the coolstore-monolith-pipeline-build template.

![](../images/scenario2/image38.png)

Follow the wizard until the end.

This will use an OpenShift Template called `coolstore-monolith-pipeline-build` to construct the production application. As you probably guessed it will also include a Jenkins Pipeline to control the production application \(more on this later!\)

Navigate to the Web Console to see your new app and the components using this link:

* Coolstore Prod Project Overview at

`https://master.[EVENT-NAME].openshiftworkshop.com/console/project/coolstore-prod/overview`

![Prod](../images/scenario2/image40.png)

You can see the production database, and an application called _Jenkins_ which OpenShift uses to manage CI/CD pipeline deployments. There is no running production app just yet. The only running app is back in the dev environment, where you used a binary build to run the app previously.

OpenShift, using Kubernetes health probes, offers a solution for monitoring application health and try to automatically heal faulty containers through restarting them to fix issues such as a deadlock in the application which can be resolved by restarting the container. Restarting a container in such a state can help to make the application more available despite bugs.

Furthermore, there are of course a category of issues that can’t be resolved by restarting the container. In those scenarios, OpenShift would remove the faulty container from the built-in load-balancer and send traffic only to the healthy container remained.  


There are two type of health probes available in OpenShift: [liveness probes and readiness probes](https://docs.openshift.com/container-platform/3.9/dev_guide/application_health.html#container-health-checks-using-probes). Liveness probes are to know when to restart a container and readiness probes to know when a Container is ready to start accepting traffic.

**Only execute these steps with your Jenkins has warning messages or errors. It's not required if its running well**.

Now we need to increase the timeout of readiness and liveness probes. Click in the jenkins application link.

![](../images/scenario2/image47.png)

Then, go to **Actions -&gt; Edit Health Checks**

![](../images/scenario2/image27.png)

Set 480 timeout seconds to both readiness and liveness probes.

![](../images/scenario2/image30.png)

After that, click in save button.

![](../images/scenario2/image44.png)In the next step, we'll promote the app from the dev environment to the production environment using an OpenShift pipeline build. Let's get going!

