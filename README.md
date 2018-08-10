# Run Guides Locally

~~~
$ git clone https://github.com/bmachado/amm-rehost-workshopper.git
$ cd amm-rehost-workshopper

$ docker run -it --rm -p 8080:8080 -v $(pwd):/app-data \
              -e CONTENT_URL_PREFIX="file:///app-data" \
              -e WORKSHOPS_URLS="file:///app-data/_workshops/rehost.yml" \
              -e LOG_TO_STDOUT=true \
              osevg/workshopper:edge
~~~
