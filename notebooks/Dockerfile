FROM rubydata/pycall-base:latest

RUN mkdir -p /notebooks/examples /notebooks/local

# Deploy matplotlib's examples
RUN mkdir -p /tmp \
	&& curl -fsSL https://github.com/mrkn/pycall.rb/archive/master.tar.gz | tar -xzf - -C /tmp \
	&& mv /tmp/pycall.rb-master/examples/notebooks /notebooks/examples/pycall.rb \
        && rm -rf /tmp/pycall.rb-master

# Install Tini
RUN wget --quiet https://github.com/krallin/tini/releases/download/v0.10.0/tini \
	&& echo "1361527f39190a7338a0b434bd8c88ff7233ce7b9a4876f3315c22fce7eca1b0 *tini" | sha256sum -c - \
	&& mv tini /usr/local/bin/tini \
	&& chmod +x /usr/local/bin/tini

ENV SHELL=/bin/bash \
    NB_USER=jovyan \
    NB_UID=1000 \
    NB_GID=100 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

ENV HOME=/home/$NB_USER

RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER \
	&& chown -R $NB_USER:$NB_GID /notebooks

USER $NB_USER

RUN ln -sf /notebooks $HOME/notebooks
RUN python3 -m ipykernel install --user --name python3 --display-name "Python $PYTHON_VERSION"
RUN iruby register

USER root

EXPOSE 8888
WORKDIR $HOME

ENTRYPOINT ["tini", "--"]
CMD ["start-notebook.sh"]

COPY start.sh /usr/local/bin/
COPY start-notebook.sh /usr/local/bin/
COPY jupyter_notebook_config.py /etc/jupyter/

USER $NB_USER
