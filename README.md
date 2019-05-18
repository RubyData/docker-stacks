# RubyData Docker Stacks

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/RubyData/docker-stacks/master?filepath=README.ipynb)

RubyData Docker stacks are a set of ready-to-run Docker images containing Jupyter and data tools for Rubyists.
This repository is based on [jupyter/docker-stacks](https://github.com/jupyter/docker-stacks).

## Quick Start

You can try the recent build of the RubyData/minimal-notebook image on mybinder.org by click the link below:

https://mybinder.org/v2/gh/RubyData/docker-stacks/master?filepath=README.ipynb

Otherwise, you can launch a single Jupyter Notebook server in a Docker container.  Two Docker images are available. You can know which one is suitable for you in [this document](how_to_select.md).

## How to run on docker in your machine

The following command pulls the latest `rubydata/datascience-notebook` image from DockerHub if it isn't available on the local machine.  It then starts a container running a Jupyter Notebook system and exposes the 8888 port so that you can connect to Jupyter Notebook.  You can see the URL of `http://<hostname>:8888/?token=<token>` in the server log in the terminal.  Visiting this URL in a Web browser, you can see Jupyter Notebook dashboard page on the browser.

```
docker run -p 8888:8888 rubydata/datascience-notebook
```

## Lisence

MIT License
