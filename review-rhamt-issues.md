# Review RHAMT Issues

Use the Issue Explorer to review migration issues identified by RHAMT.

![]({% image_path /scenario1/image31.png %})

Now we need to migrate the monolith app to Java EE standards.

1. Review the issue related to `ApplicationLifecycleListener`

Group the issues by severity only:

![]({% image_path /scenario1/image3.png %})

Navigate in the Issue Explorer until find the ApplicationLifecycleListener, or type the name of it in the search field.

Right-click on it and select **Issue Details** to view information about the RHAMT issue, including its severity and how to address it.  

![]({% image_path /scenario1/image15.png %})

RHAMT provides helpful info to understand the issue deeper and offer guidance for the migration.

![]({% image_path scenario1/image20.png %}){:width="900px"}

2. Open the file

Open the file `src/main/java/com/redhat/coolstore/utils/StartupListener.java` by double-clicking the mandatory issue with specific WebLogic source code.

![]({% image_path /scenario1/image47.png %})

It will open the associated class _StartupListener_ line of code which has the dependency in the editor.

![]({% image_path /scenario1/image64.png %})

The first issue we will tackle is the one reporting the use of _Weblogic ApplicationLifecyleEvent_ and _Weblogic LifecycleListener_ in this file. Edit the file to make these changes:

```java
package com.redhat.coolstore.utils;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;
import javax.ejb.Startup;
import javax.inject.Singleton;
import javax.inject.Inject;
import java.util.logging.Logger;

@Singleton
@Startup
public class StartupListener {

    @Inject
    Logger log;

    @PostConstruct
    public void postStart() {
        log.info("AppListener(postStart)");
    }

    @PreDestroy
    public void preStop() {
        log.info("AppListener(preStop)");
    }

}
```

3. Test the build

Build and package the app using Maven to make sure the changed code still compiles. In Project Explorer, right-click on **pom.xml → Run As → Maven Build**

![]({% image_path /scenario1/image56.png)

Fill up the goals with "clean package" and click on Run button.

![]({% image_path /scenario1/image55.png %})

If builds successfully \(you will see `BUILD SUCCESS` in the console\), then let's move on to the next issue! If it does not compile, verify you made all the changes correctly and try the build again.

![]({% image_path /scenario1/image45.png %})

Manually mark an RHAMT issue as fixed, which will mark the issue with the resolved icon \( ![Resolved issue icon]({% image_path /scenario1/image33.gif) \) until the next time that RHAMT is run on the project. To mark an issue as fixed, right-click the RHAMT issue in the Issue Explorer and select **Mark as Fixed**.

![]({% image_path /scenario1/image50.png %})

Also, you can run RHAMT again on the project to eliminate the issues already fixed. Click in the ![]({% image_path /scenario1/image22.png %})icon and then Run\_configuration

![]({% image_path /scenario1/image17.png %})

Search by `ApplicationLifecycleListener` again in the Issue Explorer and notice that it doesn't appear anymore because its fixed.

![]({% image_path /scenario1/image61.png %})

