# Promoting Apps Across Environments with Pipelines

As part of the production environment template you used in the last step, a Pipeline build object was created. Ordinarily the pipeline would contain steps to build the project in the _dev_ environment, store the resulting image in the local repository, run the image and execute tests against it, then wait for human approval to _promote_ the resulting image to other environments like test or production.

1. Inspect the Pipeline Definition

Our pipeline is somewhat simplified for the purposes of this Workshop. Inspect the contents of the pipeline using the following command:

```bash
oc projects
oc project [your-username]-coolstore-prod
oc describe bc/monolith-pipeline
```

You can see the Jenkinsfile definition of the pipeline in the output:

```text
Jenkinsfile contents:
  node ('maven') {
    stage 'Build'
    sleep 5

    stage 'Run Tests in DEV'
    sleep 10

    stage 'Deploy to PROD'
    openshiftTag(sourceStream: 'coolstore', sourceTag: 'latest', namespace: 'coolstore-dev', destinationStream: 'coolstore', destinationTag: 'prod', destinationNamespace: 'coolstore-prod')
    sleep 10

    stage 'Run Tests in PROD'
    sleep 30
  }
```

Note that source namespace refers to coolstore-dev and destinationNamespace to coolstore-prod. We will need to add \[your-username\]- in the coolstore-dev and coolstore-prod project name to associate the pipeline to the project created in the previous lab. It will be done in the next steps.

Pipeline syntax allows creating complex deployment scenarios with the possibility of defining checkpoint for manual interaction and approval process using [the large set of steps and plugins that Jenkins provides](https://jenkins.io/doc/pipeline/steps/) in order to adapt the pipeline to the process used in your team. You can see a few examples of advanced pipelines in the [OpenShift GitHub Repository](https://github.com/openshift/origin/tree/master/examples/jenkins/pipeline).

To simplify the pipeline in this workshop, we simulate the build and tests and skip any need for human input. Once the pipeline completes, it deploys the app from the dev environment to our _production_ environment using the above `openshiftTag()` method, which simply re-tags the image you already created using a tag which will trigger deployment in the production environment.

2. Promote the dev image to production using the pipeline

You can use the oc command line to invoke the build pipeline, or the Web Console. Let's use the Web Console.

First of all, let's ensure `coolstore-prod` has the user groups needed to run the pipeline. Return to the main page by clicking in openshift logo on the left top corner.

![](../images/scenario2/image49.png)

Click in the ![](../images/scenario2/image42.png)button next to the \[your-username\]-coolstore-dev project -&gt; View Membership.

![](../images/scenario2/image22.png)

Navigate to Service Groups, notice that **system:serviceaccounts:coolstore-prod** doesn't exist. The correct name is `coolstore-prod` instead, so the pipeline won't run successfully, it can't get the image streams in the `-dev` namespace. You can do the same steps in `coolstore-prod` project to check the service accounts created to its project.

![](../images/scenario2/image12.png)

The pipeline copies the ROOT.war running in developer to product environment. Without the correct service account in `coolstore-dev` project the image streams "coolstore" is forbidden and the pipeline created in `coolstore-prod` will thrown errors. So, click in Edit Membership button.

![](../images/scenario2/image23.png)

Add a new group called **system:serviceaccounts:coolstore-prod** with the admin role.

![](../images/scenario2/image19.png)

Remove the wrong role called **system.serviceaccounts:coolstore-prod**.

![](../images/scenario2/image34.png)

Click in Remove button to confirm it and Done Editing.

![](../images/scenario2/image41.png)

Now, we are going to fix the pipeline. Open the production project in the web console:

* Web Console - Coolstore Monolith Prod at

`https://master.[EVENT-NAME].openshiftworkshop.com/console/project/coolstore-prod`

Navigate to **Builds -&gt; Pipelines -&gt; monolith-pipeline**

Click in the monolith-pipeline.

![](../images/scenario2/image35.png)

Then, select **Actions -&gt; Edit**

![](../images/scenario2/image39.png)

And update the coolstore-dev namespace and coolstore-prod destinationNamespace adding \[your-username\].

![](../images/scenario2/image6.png)

The complete pipeline will be like this:

```text
Jenkinsfile contents:
  node ('maven') {
    stage 'Build'
    sleep 5

    stage 'Run Tests in DEV'
    sleep 10

    stage 'Deploy to PROD'
    openshiftTag(sourceStream: 'coolstore', sourceTag: 'latest', namespace: '[your-username]-coolstore-dev', destinationStream: 'coolstore', destinationTag: 'prod', destinationNamespace: '[your-username]-coolstore-prod')
    sleep 10

    stage 'Run Tests in PROD'
    sleep 30
  }
```

Save the pipeline by clicking in save button in the bottom of its page.

![](../images/scenario2/image33.png)

Confirm Jenkins is running before performing the next steps. Click in Overview menu option.

![](../images/scenario2/image3.png)

Open Jenkins application details ![](../images/scenario2/image14.png)

![](../images/scenario2/image21.png)

Check if it has a running status and completed with blue color

![](../images/scenario2/image15.png)

Next, click return to the **Builds -&gt; Pipeline** menu and click Start Pipeline next to the `coolstore-monolith` pipeline:

![](../images/scenario2/image8.png)

This will start the pipeline. It will take a minute or two to start the pipeline \(future runs will not take as much time as the Jenkins infrastructure will already be warmed up\). You can watch the progress of the pipeline:

![Prod](../images/scenario2/image20.png)

Once the pipeline completes, return to the Prod Project Overview at

`https://master.[EVENT-NAME].openshiftworkshop.com/console/project/coolstore-prod` and notice that the application is now deployed and running!

![Prod](../images/scenario2/image25.png)

View the production app with the blue header from before is running by clicking: CoolStore Production App at `http://www.coolstore-prod.apps.[EVENT-NAME].openshiftworkshop.com` \(it may take a few moments for the container to deploy fully.\)

