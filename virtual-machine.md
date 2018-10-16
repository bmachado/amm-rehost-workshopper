# Virtual Machine

You are receiving a virtual machine with everything you need already installed. It has a Red Hat Enterprise Linux \(RHEL\) 7.5 with RHAMT, Red Hat JBoss Developer Studio with RHAMT plugin and oc command.

To get it ready for use, you need to create a new machine and import the use an existing virtual disk file you have extracted before.

**1.** Click in create button

![VM1]({% image_path /scenario1/vm1.png %}){:width="640 px"}



**2.** Give it a name, example: AMM Rehost, with type "Linux" and Version Red Hat (64 bit)

![VM2]({% image_path /scenario1/vm2.png %}){:width="640 px"}



**3.** The minimum memory required to run ins 4096mb

![VM3]({% image_path /scenario1/vm3.png %}){:width="640 px"}



**4.** Now, choose "Use an existing virtual hard disk file" option

![VM4]({% image_path /scenario1/vm4.png %}){:width="640 px"}



**5.** And choose the RHEL7.5-AMM.vdi file

![VM5]({% image_path /scenario1/vm5.png %}){:width="640 px"}



**6.** Click in start button to start the VM.

![VM6]({% image_path /scenario1/vm6.png %}){:width="640 px"}


## Login instructions

* **Username:** {{OPENSHIFT_USERNAME}}
* **Password:** {{OPENSHIFT_PASSWORD}}

![login]({% image_path /scenario1/login.png %}){:width="640 px"}

## Accessing this documentation

**1.** After login, open Firefox web browser by clicking on Applications → Firefox Web Browser
![browser0]({% image_path /scenario1/open-browser.png %}){:width="640 px"}

**2.** Click in the first link available in browser favorites.
![browser1]({% image_path /scenario1/browser1.png %}){:width="640 px"}

**3.** Replace the **repl** part of the url with your guid.
![browser2]({% image_path /scenario1/browser2.png %}){:width="640 px"}

In this example, it would be http://testdrive-workshopper.apps-1336.generic.opentlc.com
