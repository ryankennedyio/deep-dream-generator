# deep-dream-generator

####\#deepdream in a docker environment, to save you 8 hours of setup headaches.

To set up the container, you can either build it yourself from here - or just fetch it from Dockerhub.

Once you have a container ready, run it with

	docker run -d -p 443:8888 -e "PASSWORD=password" -v /path/to/this/repository:/src ryankennedyio/deepdream

Then head to https://{dockerIP}/, enter 'password' and start playing. 