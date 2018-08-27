# Promoting Apps Across Environments with Pipelines

As part of the production environment template you used in the last step, a Pipeline build object was created. Ordinarily the pipeline would contain steps to build the project in the _dev_ environment, store the resulting image in the local repository, run the image and execute tests against it, then wait for human approval to _promote_ the resulting image to other environments like test or production.

**1.** Inspect the Pipeline Definition

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

Note that source namespace refers to coolstore-dev and destinationNamespace to coolstore-prod.

Pipeline syntax allows creating complex deployment scenarios with the possibility of defining checkpoint for manual interaction and approval process using [the large set of steps and plugins that Jenkins provides](https://jenkins.io/doc/pipeline/steps/) in order to adapt the pipeline to the process used in your team. You can see a few examples of advanced pipelines in the [OpenShift GitHub Repository](https://github.com/openshift/origin/tree/master/examples/jenkins/pipeline).

To simplify the pipeline in this workshop, we simulate the build and tests and skip any need for human input. Once the pipeline completes, it deploys the app from the dev environment to our _production_ environment using the above `openshiftTag()` method, which simply re-tags the image you already created using a tag which will trigger deployment in the production environment.

**2.** Promote the dev image to production using the pipeline

You can use the oc command line to invoke the build pipeline, or the Web Console. Let's use the Web Console.

>Confirm Jenkins is running before performing the next steps.

Click in Overview menu option.

![]({% image_path /scenario2/image3.png %}){:width="650 px"}

Click in the icon below ![]({% image_path /scenario2/image14.png %}){:width="20 px"}
It will open Jenkins application details
![]({% image_path /scenario2/image21.png %}){:width="650 px"}
<br><br><br>
Check if it has a running status and completed with blue color
![]({% image_path /scenario2/image15.png %}){:width="650 px"}
<br><br><br>
Next, click return to the **Builds → Pipeline** menu and click Start Pipeline next to the `coolstore-monolith` pipeline:

![]({% image_path /scenario2/image8.png %}){:width="650 px"}

This will start the pipeline. It will take a minute or two to start the pipeline \(future runs will not take as much time as the Jenkins infrastructure will already be warmed up\). You can watch the progress of the pipeline:

![Prod]({% image_path /scenario2/image20.png %}){:width="650 px"}

Once the pipeline completes, return to the Prod Project Overview at

`{{OPENSHIFT_MASTER_URL}}/console/project/coolstore-prod` and notice that the application is now deployed and running!

![Prod]({% image_path /scenario2/image25.png %}){:width="650 px"}

View the production app with the blue header from before is running by clicking: CoolStore Production App at `{{OPENSHIFT_COOLSTORE_DEV_URL}}` \(it may take a few moments for the container to deploy fully.\)

