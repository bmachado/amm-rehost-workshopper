# Configuring the JBoss EAP

Our application is at this stage pretty standards based, but it needs two things. First we need to add the JMS Topic since our application depends on it. Second, the application depends on a DataSource to establish connections to a database.

In terminal window, type the following commands:

```bash
cd $HOME/projects/monolith
export JBOSS_HOME=$HOME/jboss-eap-7.1
mvn wildfly:start wildfly:add-resource wildfly:shutdown
```

Wait for a `BUILD SUCCESS` message. If it fails, check that you made all the correct changes and try again!

NOTE: The reason we are using `wildfly:start` and `wildfly:shutdown` is because the `add-resource` command requires a running server. After we have added these resource we don't have to run this command again.

Those commands used maven plugin to start the JBoss EAP 7.1 process, add the resources needed and shutdown it. Once configured, maven plugin is responsible to control it for you.

