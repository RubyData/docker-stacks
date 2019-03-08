FROM rubylang/ruby

LABEL maintainer "Kenta Murata <mrkn@mrkn.jp>"

USER root

ENV DEBIAN_FRONTEND noninteractive

###############################################################
# Prerequisites
###############################################################

RUN set -ex \
	&& apt update \
	&& apt install -y --no-install-recommends \
		build-essential \
		curl \
		gnupg \
		sqlite3 \
		libsqlite3-dev

###############################################################
# Tini
###############################################################

RUN set -ex \
	&& curl -sfSL -O https://github.com/krallin/tini/releases/download/v0.10.0/tini \
	&& echo "1361527f39190a7338a0b434bd8c88ff7233ce7b9a4876f3315c22fce7eca1b0 *tini" | sha256sum -c - \
	&& mv tini /usr/local/bin/tini \
	&& chmod +x /usr/local/bin/tini

###############################################################
# Apache Arrow
###############################################################

RUN set -ex \
	&& apt update \
	&& apt install -y --no-install-recommends \
		apt-transport-https \
		lsb-release \
	&& curl -sfSL -o /usr/share/keyrings/apache-arrow-keyring.gpg \
		https://dl.bintray.com/apache/arrow/$(lsb_release --id --short | tr 'A-Z' 'a-z')/apache-arrow-keyring.gpg \
	&& { \
		echo "deb [arch=amd64 signed-by=/usr/share/keyrings/apache-arrow-keyring.gpg] https://dl.bintray.com/apache/arrow/$(lsb_release --id --short | tr 'A-Z' 'a-z')/ $(lsb_release --codename --short) main"; \
		echo "deb-src [signed-by=/usr/share/keyrings/apache-arrow-keyring.gpg] https://dl.bintray.com/apache/arrow/$(lsb_release --id --short | tr 'A-Z' 'a-z')/ $(lsb_release --codename --short) main"; \
           } >> /etc/apt/sources.list.d/apache-arrow.list \
	&& apt update \
	&& apt install -y --no-install-recommends \
		libarrow-dev \
		libarrow-glib-dev \
		libplasma-dev \
		libplasma-glib-dev \
		libgandiva-dev \
		libgandiva-glib-dev \
		libparquet-dev \
		libparquet-glib-dev

###############################################################
# Ruby based on docker-library/ruby
###############################################################

# skip installing gem documentation
RUN mkdir -p /usr/local/etc \
	&& { \
		echo 'install: --no-document'; \
		echo 'update: --no-document'; \
	} >> /usr/local/etc/gemrc

# install things globally, for great justice
# and don't create ".bundle" in all our apps
ENV GEM_HOME /usr/local/bundle
ENV BUNDLE_PATH="$GEM_HOME" \
    BUNDLE_BIN="$GEM_HOME/bin" \
    BUNDLE_SILENCE_ROOT_WARNING=1 \
    BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH $BUNDLE_BIN:$PATH
RUN mkdir -p "$GEM_HOME" "$BUNDLE_BIN" \
	&& chmod 777 "$GEM_HOME" "$BUNDLE_BIN"

###############################################################
# Python based on docker-library/python
###############################################################

# ensure local python is preferred over distribution python
ENV PATH /usr/local/bin:$PATH

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

# runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
		tcl \
		tk \
	&& rm -rf /var/lib/apt/lists/*

ENV GPG_KEY 0D96DF4D4110E5C43FBFB17F2D347EA6AA65421D
ENV PYTHON_VERSION 3.7.2

# if this is called "PIP_VERSION", pip explodes with "ValueError: invalid truth value '<VERSION>'"
ENV PYTHON_PIP_VERSION 19.0.3

RUN set -ex \
	&& buildDeps=' \
		tcl-dev \
		tk-dev \
	' \
	&& apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
	\
	&& curl -sfSL -o python.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz" \
	&& curl -sfSL -o python.tar.xz.asc "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz.asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ipv4.pool.sks-keyservers.net --recv-keys "$GPG_KEY" \
	&& gpg --batch --verify python.tar.xz.asc python.tar.xz \
	&& rm -r "$GNUPGHOME" python.tar.xz.asc \
	&& mkdir -p /usr/src/python \
	&& tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz \
	&& rm python.tar.xz \
	\
	&& cd /usr/src/python \
	&& ./configure \
		--enable-loadable-sqlite-extensions \
		--enable-shared \
	&& make -j$(nproc) \
	&& make install \
	&& ldconfig \
	\
# explicit path to "pip3" to ensure distribution-provided "pip3" cannot interfere
	&& if [ ! -e /usr/local/bin/pip3 ]; then : \
		&& curl -sfSL -o /tmp/get-pip.py 'https://bootstrap.pypa.io/get-pip.py' \
		&& python3 /tmp/get-pip.py "pip==$PYTHON_PIP_VERSION" \
		&& rm /tmp/get-pip.py \
	; fi \
# we use "--force-reinstall" for the case where the version of pip we're trying to install is the same as the version bundled with Python
# ("Requirement already up-to-date: pip==8.1.2 in /usr/local/lib/python3.6/site-packages")
# https://github.com/docker-library/python/pull/143#issuecomment-241032683
	&& pip3 install --no-cache-dir --upgrade --force-reinstall "pip==$PYTHON_PIP_VERSION" \
# then we use "pip list" to ensure we don't have more than one pip version installed
# https://github.com/docker-library/python/pull/100
	&& [ "$(pip list |tac|tac| awk -F '[ ()]+' '$1 == "pip" { print $2; exit }')" = "$PYTHON_PIP_VERSION" ] \
	\
	&& find /usr/local -depth \
		\( \
			\( -type d -a -name test -o -name tests \) \
			-o \
			\( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
		\) -exec rm -rf '{}' + \
	&& apt-get purge -y --auto-remove $buildDeps \
	&& rm -rf /usr/src/python ~/.cache

# make some useful symlinks that are expected to exist
RUN cd /usr/local/bin \
	&& { [ -e easy_install ] || ln -s easy_install-* easy_install; } \
	&& ln -s idle3 idle \
	&& ln -s pydoc3 pydoc \
	&& ln -s python3 python \
	&& ln -s python3-config python-config


###############################################################
# Extra things
###############################################################

RUN set -ex \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
		libopenblas-dev \
		liblapacke-dev \
		libczmq-dev \
		sqlite3 libsqlite3-dev \
		mysql-client libmysqlclient-dev \
		postgresql-client libpq-dev

ADD requirements.txt /tmp
RUN pip3 install -r /tmp/requirements.txt && rm -f /tmp/requirements.txt

RUN apt-get update \
	&& apt-get install -y --no-install-recommends nodejs npm \
	&& npm install -g n \
	&& n latest \
	&& apt-get purge -y nodejs npm \
	&& apt-get autoremove -y
RUN jupyter labextension install @jupyterlab/plotly-extension \
	&& jupyter labextension install jupyterlab_bokeh \
	&& jupyter lab build

RUN gem install  \
	ffi-rzmq \
	pry \
	pry-doc \
	awesome_print

RUN gem install iruby \
	&& gem install pycall -v '1.0.3' \
	&& gem install numpy \
	&& gem install pandas \
	&& gem install matplotlib \
	&& gem install numo-narray -v '0.9.1.2' \
	&& gem install numo-linalg \
	&& gem install nmatrix \
	&& gem install nmatrix-lapacke \
	&& gem install red-arrow \
	&& gem install red-arrow-numo-narray \
	&& gem install red-arrow-nmatrix \
	&& gem install red-parquet \
	&& gem install red-datasets \
	&& gem install red-chainer \
	&& gem install daru \
	&& gem install spreadsheet \
	&& gem install mechanize \
	&& gem install rbplotly \
	&& gem install activerecord \
	&& gem install sqlite3 \
	&& gem install mysql2 \
	&& gem install pg

ENTRYPOINT ["tini", "--"]
CMD ["/bin/bash"]
