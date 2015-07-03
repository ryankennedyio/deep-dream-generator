FROM ipython/ipython:3.x

MAINTAINER IPython Project <ipython-dev@scipy.org>

VOLUME /notebooks
WORKDIR /notebooks

EXPOSE 8888

# You can mount your own SSL certs as necessary here
ENV PEM_FILE /key.pem
# $PASSWORD will get `unset` within notebook.sh, turned into an IPython style hash
ENV PASSWORD Dont make this your default
ENV USE_HTTP 0

RUN apt-get update

RUN apt-get install -y wget

#Fetch Anaconda
RUN wget http://09c8d0b2229f813c1b93-c95ac804525aac4b6dba79b00b39d1d3.r79.cf1.rackcdn.com/Anaconda-2.0.1-Linux-x86_64.sh

#Install Anaconda
RUN bash /Anaconda-2.0.1-Linux-x86_64.sh -b

ENV PATH=/root/anaconda/bin:$PATH
RUN yes | conda update conda 

#Install caffe deep learning libs
RUN apt-get install -y libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libboost-all-dev libhdf5-serial-dev

RUN easy_install protobuf

#Install remaining deep learning dependancies
RUN apt-get install -y libgflags-dev libgoogle-glog-dev liblmdb-dev protobuf-compiler
RUN apt-get install -y libjpeg-dev
RUN apt-get install -y libjpeg62


#Install atlas
RUN apt-get install -y libatlas-base-dev

## Install Caffe
ADD caffe-master /caffe-master

RUN cd /caffe-master && make && make distribute

ENV PYTHONPATH=/caffe-master/distribute/python
ENV PATH $PATH:/opt/caffe/.build_release/tools

# Add ld-so.conf so it can find libcaffe.so
ADD caffe-ld-so.conf /etc/ld.so.conf.d/

# Run ldconfig again (not sure if needed)
RUN ldconfig

ADD notebook.sh /

RUN chmod u+x /notebook.sh

CMD ["/notebook.sh"]

#TO RUN - docker run -d -p 443:8888 -e "PASSWORD=password" -v /path/to/this/repository:/src ipython/notebook