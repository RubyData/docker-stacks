# RubyData notebook image

This docker image provides Jupyter Notebook environment with Ruby's data science stack.

## Components in this image

- Based on RubyData/base:latest image
- Things provided by jupyter/datascience-notebook image:
  - Unprivileged user `jovyan` (uid=1000, configurable, see options) in group `users` (gid=100) with ownership over `/home/jovyan`.
  - [start-notebook.sh]() as the default command
  - A [start.sh]() script useful for running alternative commands in the container (e.g. `iruby`, `ipython`, `jupyter kernelgateway`, `jupyter lab`)

## Basic Usage

The following command starts a container with the Notebook server listening for HTTP connections on port 8888 with a randomly generated authentication token configured.

```
docker run -it --rm -p 8888:8888 rubydata/notebook
```

Take note of the authentication token included in the notebook startup log message.  Include it in the URL you visit to access the Notebook server or enter it in the Notebook login form.

## Notebook Options

The Docker container executes a [`start-notebook.sh`]() script by default.  The `start-notebook.sh` script handles the `NB_UID`, `NB_GID` and `GRANT_SUDO` features documented in the next section, and then executes the `jupyter notebook`.

You can pass [Jupyter command line options]() through the `start-notebook.sh` script when launching the container.  For example, to secure the Notebook server with a custom password hashed using `IPython.lib.password()` instead of the default token, run the following:

```
docker run -d -p 8888:8888 rubydata/notebook start-notebook.sh --NotebookApp.password='sha1:74ba40f8a388:c913541b7ee99d15d5ed31d4226bf7838f83a50e'
```

For example, to set the base URL of the notebook server, run the following:

```
docker run -d -p 8888:8888 rubydata/notebook start-notebook.sh --NotebookApp.base_url=/some/path
```

For example, to disable all authentication mechanisms (not a recommended practice):

```
docker run -d -p 8888:8888 rubydata/notebook start-notebook.sh --NotebookApp.token=''
```

You can sidestep the `start-notebook.sh` script and run your own commands in the container.  See the _Alternative Commands_ section later in this document for more information.

## Docker Options

You may customize the execution of the Docker container and the command it is running with the following optional arguments.

- `-e GEN_CERT=yes` - Generates a self-signed SSL certificate and configures Jupyter Notebook to use it to accept encrypted HTTPS connections.
- `-e NB_UID=1000` - Specify the uid of the `jovyan` user.  Useful to mount host volumes with specific file ownership.  For this option to take effect, you must run the container with `--user root`.  (The `start-notebook.sh` script will `su jovyan` after adjusting the user id.)
- `-e NB_GID=100` - Specify the gid of the `jovyan` user.  Useful to mount host volumes with specific file ownership.  For this option to take effect, you must run the container with `--user root`.  (The `start-notebook.sh` script will `su jovyan` after adjusting the group id.)
- `-e GRANT_SUDO=yes` - Gives the `jovyan` user passwordless `sudo` capability.  Useful for installing OS packages.  FOr this option to take effect, you must run the container with `--user root`.  (The `start-notebook.sh` script will `su jovyan` after adding `jovyan` to sudoers.)  __You should only enable `sudo` if you trust the user or if the container is running on an isolated host__.
- `-v /some/host/folder/for/work:/home/jovyan/work` - Mounts a host machine directory as folder in the container.  Useful when you want to preserve notebooks and other work even after the container is destroyed.  __You must grant the within-container notebook user and group (`NB_UID` and `NB_GID`) write access to the host directory (e.g. `sudo chown 1000 /some/host/folder/for/work`__.)

## Alternative Commands

### start.sh

The `start.sh` script supports the same features as the default `start-notebook.sh` script (e.g., `GRANT_SUDO`), but allows you to specify an arbitrary command to execute.  For example, to run the text-based `iruby` console in a container, do the following:

```
docker run -it --rm rubydata/notebook start.sh iruby
```

Or, to run JupyterLab instead of the classic notebook, run the following:

```
docker run -it --rm -p 8888:8888 rubydata/notebook start.sh jupyter lab
```

This script is particularly useful when you derive a new Dockefile from this image and install additional Jupyter applications with subcommands like `jupyter console`, `jupyter kernelgateway`, etc.

### Others

You can bypass the provided scripts and specify your an arbitrary start command.  If you do, keep in mind that certain features documented above will not function (e.g., `GRANT_SUDO`).
