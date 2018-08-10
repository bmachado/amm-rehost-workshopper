# Verifying the Dev Environment

## 1. Verify Application

You can review the above resources in the OpenShift Web Console or using the oc get or oc describe commands \(oc describe gives more detailed info\):

You can use short synonyms for long words, like bc instead of buildconfig, and is for imagestream, dc for deploymentconfig, svc for service, etc.

Don't worry about reading and understanding the output of oc describe. Just make sure the command doesn't report errors!

Run these commands to inspect the elements:

```bash
oc get bc coolstore
oc get is coolstore
oc get dc coolstore
oc get svc coolstore
oc describe route www
```

Verify that you can access the monolith by clicking on the exposed OpenShift route at

http://www-\[your-username\]-coolstore-dev.apps.\[EVENT-NAME\].openshiftworkshop.com to open up the sample application in a separate browser tab. Full link is listed in Requested Host attribute.

You should also be able to see both the CoolStore monolith and its database running in separate pods:

```bash
oc get pods -l application=coolstore
```

The output should look like this:

```text
NAME                           READY STATUS RESTARTS AGE
coolstore-2-bpkkc              1/1 Running 0 4m
coolstore-postgresql-1-jpcb8   1/1 Running 0 9m
```

##  ****2. Verify Database

You can log into the running Postgres container using the following:

```bash
oc rsh dc/coolstore-postgresql
```

Once logged in, use the following command to execute an SQL statement to show some content from the database:

```bash
psql -U $POSTGRESQL_USER $POSTGRESQL_DATABASE -c 'select name from PRODUCT_CATALOG;'
```

`$POSTGRESQL_USER` and `$POSTGRESQL_DATABASE` environment variables are already defined. If you want to check tem run the following commands:

```text
echo $POSTGRESQL_USER
echo $POSTGRESQL_DATABASE
```

You should see the following:

```bash
         name
------------------------
 Red Fedora
 Forge Laptop Sticker
 Solid Performance Polo
 Ogio Caliber Polo
 16 oz. Vortex Tumbler
 Atari 2600 Joystick
 Pebble Smart Watch
 Oculus Rift
 Lytro Camera
(9 rows)
```

Don't forget to exit the pod's shell with exit

```bash
sh-4.2$ exit
```

You can also login in the management web console and run the same SQL query from your browser since Openshift provides a terminal window. Access [https://master.\[EVENT-NAME\].openshiftworkshop.com/console](about:blank) and follow the steps below:

Choose the **Coolstore Monolith - Dev** in the projects menu.

![](../images/scenario2/image17.png)

Expands the **coolstore-postgresql**

![](../images/scenario2/image11.png)

Click in the number of running pods

![](../images/scenario2/image4.png)

Go to **terminal** tab menu

![](../images/scenario2/image28.png)

Run the same SQL Query command you executed previously:

```bash
psql -U $POSTGRESQL_USER $POSTGRESQL_DATABASE -c 'select name from PRODUCT_CATALOG;'
```

\*\*\*\*

![](../images/scenario2/image46.png)

Also, explore the Environment tab also available and see the same environment variables you’ve seen before.

![](../images/scenario2/image10.png)

With our running project on OpenShift, in the next step we'll explore how you as a developer can work with the running app to make changes and debug the application!  


