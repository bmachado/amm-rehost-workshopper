# Adding Pipeline Approval Steps

## 1. Edit the pipeline

Ordinarily your pipeline definition would be checked into a source code management system like Git, and to change the pipeline you'd edit the Jenkinsfile in the source base. For this workshop we'll just edit it directly to add the necessary changes. You can edit it with the oc command but we'll use the Web Console.

Open the monolith-pipeline configuration page in the Web Console \(you can navigate to it from **Builds → Pipelines** but here's a quick link\):

* Pipeline Config page at

https://master.\[EVENT-NAME\].openshiftworkshop.com/console/project/\[your-username\]-coolstore-prod/browse/pipelines/monolith-pipeline?tab=configuration

On this page you can see the pipeline definition. Click **Actions → Edit** to edit the pipeline:

![Prod](../images/scenario2/image48.png)

In the pipeline definition editor, add a new stage to the pipeline, just before the Deploy to PROD step:

You will need to copy and paste the below code into the right place as shown in the below image.

```yaml
stage 'Approve Go Live'
  timeout(time:30, unit:'MINUTES') {
    input message:'Go Live in Production (switch to new version)?'
  }
```

 Your final pipeline should look like:

![Prod](../images/scenario2/image26.png)

Click **Save.**

## 2. Make a simple change to the app

With the approval step in place, let's simulate a new change from a developer who wants to change the color of the header in the coolstore back to the original \(black\) color.

As a developer you can easily un-do edits you made earlier to the CSS file using the source control management system \(Git\). To revert your changes, execute:

```bash
git checkout src/main/webapp/app/css/coolstore.css
```

Next, re-build the app once more:

```bash
mvn clean package -Popenshift
```

And re-deploy it to the dev environment using a binary build just as we did before:

```bash
oc start-build -n [your-username]-coolstore-dev coolstore --from-file=${HOME}/projects/monolith/deployments/ROOT.war
```

Now wait for it to complete the deployment:

```bash
oc -n [your-username]-coolstore-dev rollout status -w dc/coolstore
```

And verify that the original black header is visible in the dev application:

* Coolstore - Dev at

http://www-\[your-username\]-coolstore-dev.apps.\[EVENT-NAME\].openshiftworkshop.com

![Prod](../images/scenario2/image1.png)

While the production application is still blue:

* Coolstore - Prod at

http://www-\[your-username\]-coolstore-prod.apps.\[EVENT-NAME\].openshiftworkshop.com

![Prod](../images/scenario2/image2.png)

We're happy with this change in dev, so let's promote the new change to prod, using the new approval step!

## 3. Run the pipeline again

Invoke the pipeline once more by clicking Start Pipeline on the Pipeline Config page at

https://master.\[EVENT-NAME\].openshiftworkshop.com/console/project/\[your-username\]-coolstore-prod/browse/pipelines/monolith-pipeline

The same pipeline progress will be shown, however before deploying to prod, you will see a prompt in the pipeline:

![Prod](../images/scenario2/image13.png)

Click on the link for Input Required. This will open a new tab and direct you to Jenkins itself, where you can login with the same credentials as OpenShift:

* **Username:** userN
* **Password:** openshift

Accept the browser certificate warning and the Jenkins/OpenShift permissions, and then you'll find yourself at the approval prompt:

![Prod](../images/scenario2/image9.png)

## 4. Approve the change to go live

Click Proceed, which will approve the change to be pushed to production. You could also have clicked Abort which would stop the pipeline immediately in case the change was unwanted or unapproved.

Once you click Proceed, you will see the log file from Jenkins showing the final progress and deployment.

Wait for the production deployment to complete:

```text
oc rollout -n [your-username]-coolstore-prod status dc/[your-username]-coolstore-prod
```

Once it completes, verify that the production application has the new change \(original black header\):

* Coolstore - Prod at

http://www-\[your-username\]-coolstore-prod.apps.\[EVENT-NAME\].openshiftworkshop.com

![Prod](../images/scenario2/image1.png)

