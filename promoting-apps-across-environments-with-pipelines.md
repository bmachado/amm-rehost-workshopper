# Promoting Apps Across Environments with Pipelines

As part of the production environment template you used in the last step, a Pipeline build object was created. Ordinarily the pipeline would contain steps to build the project in the _dev_ environment, store the resulting image in the local repository, run the image and execute tests against it, then wait for human approval to _promote_ the resulting image to other environments like test or production.

1. Inspect the Pipeline Definition

Our pipeline is somewhat simplified for the purposes of this Workshop. Inspect the contents of the pipeline using the following command:

~~~shell
oc projects
oc project [your-username]-coolstore-prod
oc describe bc/monolith-pipeline
~~~

You can see the Jenkinsfile definition of the pipeline in the output:

~~~text
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
~~~

Note that source namespace refers to coolstore-dev and destinationNamespace to coolstore-prod. We will need to add \[your-username\]- in the coolstore-dev and coolstore-prod project name to associate the pipeline to the project created in the previous lab. It will be done in the next steps.

Pipeline syntax allows creating complex deployment scenarios with the possibility of defining checkpoint for manual interaction and approval process using [the large set of steps and plugins that Jenkins provides](https://jenkins.io/doc/pipeline/steps/) in order to adapt the pipeline to the process used in your team. You can see a few examples of advanced pipelines in the [OpenShift GitHub Repository](https://github.com/openshift/origin/tree/master/examples/jenkins/pipeline).

To simplify the pipeline in this workshop, we simulate the build and tests and skip any need for human input. Once the pipeline completes, it deploys the app from the dev environment to our _production_ environment using the above `openshiftTag()` method, which simply re-tags the image you already created using a tag which will trigger deployment in the production environment.

2. Promote the dev image to production using the pipeline

You can use the oc command line to invoke the build pipeline, or the Web Console. Let's use the Web Console.

First of all, let's ensure `coolstore-prod` has the user groups needed to run the pipeline. Return to the main page by clicking in openshift logo on the left top corner.

![]({% image_path /scenario2/image49.png %}){:width="650 px"}

Click in the ![]({% image_path /scenario2/image42.png %}){:width="30 px"}button next to the \[your-username\]-coolstore-dev project -&gt; View Membership.

![]({% image_path /scenario2/image22.png %}){:width="450 px"}

Navigate to Service Groups, notice that **system:serviceaccounts:coolstore-prod** doesn't exist. The correct name is `coolstore-prod` instead, so the pipeline won't run successfully, it can't get the image streams in the `-dev` namespace. You can do the same steps in `coolstore-prod` project to check the service accounts created to its project.

![]({% image_path /scenario2/image12.png %}){:width="650 px"}

The pipeline copies the ROOT.war running in developer to product environment. Without the correct service account in `coolstore-dev` project the image streams "coolstore" is forbidden and the pipeline created in `coolstore-prod` will thrown errors. So, click in Edit Membership button.

![]({% image_path /scenario2/image23.png %}){:width="650 px"}

Add a new group called **system:serviceaccounts:coolstore-prod** with the admin role.

![]({% image_path /scenario2/image19.png %}){:width="650 px"}

Remove the wrong role called **system.serviceaccounts:coolstore-prod**.

![]({% image_path /scenario2/image34.png %}){:width="650 px"}

Click in Remove button to confirm it and Done Editing.

![]({% image_path /scenario2/image41.png %}){:width="650 px"}

Now, we are going to fix the pipeline. Open the production project in the web console:

* Web Console - Coolstore Monolith Prod at

`https://master.[EVENT-NAME].openshiftworkshop.com/console/project/coolstore-prod`

Navigate to **Builds -&gt; Pipelines -&gt; monolith-pipeline**

Click in the monolith-pipeline.

![]({% image_path /scenario2/image35.png %}){:width="650 px"}

Then, select **Actions -&gt; Edit**

![]({% image_path /scenario2/image39.png %}){:width="650 px"}

And update the coolstore-dev namespace and coolstore-prod destinationNamespace adding \[your-username\].

![]({% image_path /scenario2/image6.png %}){:width="650 px"}

The complete pipeline will be like this:

~~~text
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
~~~

Save the pipeline by clicking in save button in the bottom of its page.

![]({% image_path /scenario2/image33.png %}){:width="650 px"}

Confirm Jenkins is running before performing the next steps. Click in Overview menu option.

![]({% image_path /scenario2/image3.png %}){:width="650 px"}

Open Jenkins application details ![]({% image_path /scenario2/image14.png %}){:width="30 px"}

![]({% image_path /scenario2/image21.png %}){:width="650 px"}

Check if it has a running status and completed with blue color

![]({% image_path /scenario2/image15.png %}){:width="650 px"}

Next, click return to the **Builds -&gt; Pipeline** menu and click Start Pipeline next to the `coolstore-monolith` pipeline:

![]({% image_path /scenario2/image8.png %}){:width="650 px"}

This will start the pipeline. It will take a minute or two to start the pipeline \(future runs will not take as much time as the Jenkins infrastructure will already be warmed up\). You can watch the progress of the pipeline:

![Prod]({% image_path /scenario2/image20.png %}){:width="650 px"}

Once the pipeline completes, return to the Prod Project Overview at

`https://master.[EVENT-NAME].openshiftworkshop.com/console/project/coolstore-prod` and notice that the application is now deployed and running!

![Prod]({% image_path /scenario2/image25.png %}){:width="650 px"}

View the production app with the blue header from before is running by clicking: CoolStore Production App at `http://www.coolstore-prod.apps.[EVENT-NAME].openshiftworkshop.com` \(it may take a few moments for the container to deploy fully.\)

