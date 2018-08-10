# Deploy On OpenShift

You can deploy this test drive as a container image anywhere but most conveniently, you can deploy it on OpenShift or Minishift:

~~~shell
oc new-project workshopper
oc new-app quay.io/osevg/workshopper --name=testdrive -e WORKSHOPS_URLS="https://raw.githubusercontent.com/bmachado/amm-rehost-workshopper/master/_workshops/rehost.yml"
oc expose svc/testdrive
~~~

# Run Guides Locally

~~~shell
$ git clone https://github.com/bmachado/amm-rehost-workshopper.git
$ cd amm-rehost-workshopper

$ docker run -it --rm -p 8080:8080 -v $(pwd):/app-data \
              -e CONTENT_URL_PREFIX="file:///app-data" \
              -e WORKSHOPS_URLS="file:///app-data/_workshops/rehost.yml" \
              -e LOG_TO_STDOUT=true \
              osevg/workshopper:edge
~~~
