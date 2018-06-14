FROM registry.datadrivendiscovery.org/jpl/docker_images/complete:ubuntu-artful-python36-devel-20180419-092215

ENV HOME=/app

WORKDIR $HOME

# copy files that define dependencies so we can have package installs in a separate image layer 
COPY requirements.txt $HOME/
# install required packages on pypi
RUN pip3 install -r requirements.txt

# Install set2vec: clone from git repo, compile binary, then install python bindings
RUN git clone https://github.com/epfml/sent2vec.git $HOME/sent2vec \
    && rm -rf $HOME/sent2vec/.git* \
    && cd $HOME/sent2vec \
    && make \
    && cd $HOME/sent2vec/src \
    && python3 setup.py build_ext \
    && pip3 install . 

# install nk_sent2vec
COPY . $HOME/
RUN python3 setup.py install 

# check that it runs by triggering tests
CMD nosetests
