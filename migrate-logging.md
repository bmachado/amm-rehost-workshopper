# Migrate Logging

In this step we will migrate some Weblogic-specific code in the app to use standard Java EE interfaces.

The _**WebLogic NonCatalogLogger**_ is not supported on JBoss EAP \(or any other Java EE platform\), and should be migrated to a supported logging framework.

We will use the standard Java Logging framework, a much more portable framework. The framework also [supports internationalization](https://docs.oracle.com/javase/8/docs/technotes/guides/logging/overview.html#a1.17) if needed.

1. Open the file

Open the offending file using Issue Explorer tab. Navigate until OrderServiceMDB and double-click in `NonCatalogLogger` issue. `src/main/java/com/redhat/coolstore/service/OrderServiceMDB.java`

![](../images/scenario1/image13.png)

2. Make the changes

Open the file to make these changes:

Basically, it consists in replacing the `NonCatalogLogger` and the imports by using `java.util.logging.Logger`

```java
 private Logger log = Logger.getLogger(OrderServiceMDB.class.getName());
```

See the source code below:

```java
package com.redhat.coolstore.service;

import javax.ejb.ActivationConfigProperty;
import javax.ejb.MessageDriven;
import javax.inject.Inject;
import javax.jms.JMSException;
import javax.jms.Message;
import javax.jms.MessageListener;
import javax.jms.TextMessage;

import com.redhat.coolstore.model.Order;
import com.redhat.coolstore.utils.Transformers;

import java.util.logging.Logger;

@MessageDriven(name = "OrderServiceMDB", activationConfig = {
 @ActivationConfigProperty(propertyName = "destinationLookup", propertyValue = "topic/orders"),
 @ActivationConfigProperty(propertyName = "destinationType", propertyValue = "javax.jms.Topic"),
 @ActivationConfigProperty(propertyName = "acknowledgeMode", propertyValue = "Auto-acknowledge")})
public class OrderServiceMDB implements MessageListener {

 @Inject
 OrderService orderService;

 @Inject
 CatalogService catalogService;

 private Logger log = Logger.getLogger(OrderServiceMDB.class.getName());

 @Override
 public void onMessage(Message rcvMessage) {
 TextMessage msg = null;
 try {
 if (rcvMessage instanceof TextMessage) {
 msg = (TextMessage) rcvMessage;
 String orderStr = msg.getBody(String.class);
 log.info("Received order: " + orderStr);
 Order order = Transformers.jsonToOrder(orderStr);
 log.info("Order object is " + order);
 orderService.save(order);
 order.getItemList().forEach(orderItem -> {
 catalogService.updateInventoryItems(orderItem.getProductId(), orderItem.getQuantity());
 });
 }
 } catch (JMSException e) {
 throw new RuntimeException(e);
 }
 }

}
```

That one was pretty easy.

Mark the issues related to this as fixed.

![](../images/scenario1/image32.png)

