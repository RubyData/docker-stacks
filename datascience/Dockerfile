ARG BASE_IMAGE_TAG=65c71a997042
FROM jupyter/datascience-notebook:$BASE_IMAGE_TAG

LABEL maintainer="Kenta Murata <mrkn@mrkn.jp>"

USER root

# Pre-requisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
            ca-certificates \
            curl \
            gcc \
            libczmq-dev \
            libffi-dev \
            libgdbm-dev \
            libgmp-dev \
            liblapacke-dev \
            libmysqlclient-dev \
            libncurses5-dev \
            libopenblas-dev \
            libpq-dev \
            libreadline-dev \
            libsqlite3-dev \
            libssl-dev \
            libxml2-dev \
            libxslt1-dev \
            libyaml-dev \
            libzmq3-dev \
            mysql-client \
            pkg-config \
            postgresql-client \
            sqlite3 \
            tzdata \
            zlib1g-dev && \
    rm -rf /var/lib/apt/lists/*

# Apache Arrow

RUN apt update && \
    apt install -y --no-install-recommends \
        apt-transport-https \
        lsb-release \
        && \
    \
    curl -sfSL -o /tmp/apache-arrow-apt-source-latest.deb \
         https://apache.jfrog.io/artifactory/arrow/$(lsb_release --id --short | tr 'A-Z' 'a-z')/apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb && \
    apt install -y --no-install-recommends \
        /tmp/apache-arrow-apt-source-latest.deb && \
    rm -f /tmp/apache-arrow-apt-source-latest.deb && \
    \
    apt update && \
    apt install -y --no-install-recommends \
        libarrow-dev \
        libarrow-glib-dev \
        libplasma-dev \
        libplasma-glib-dev \
        libgandiva-dev \
        libgandiva-glib-dev \
        libparquet-dev \
        libparquet-glib-dev \
        libgirepository1.0-dev \
        && \
    \
    rm -rf /var/lib/apt/lists/*

# Copy Ruby 3.0.1 from rubylang/ruby

COPY --from=rubylang/ruby:3.0.1-focal \
     /usr/local/bin/bundle \
     /usr/local/bin/bundler \
     /usr/local/bin/erb \
     /usr/local/bin/gem \
     /usr/local/bin/irb \
     /usr/local/bin/racc \
     /usr/local/bin/rake \
     /usr/local/bin/rdoc \
     /usr/local/bin/ri \
     /usr/local/bin/ruby \
     /usr/local/bin/

COPY --from=rubylang/ruby:3.0.1-focal \
     /usr/local/etc/gemrc \
     /usr/local/etc/

# NOTE: DO NOT CHANGE the version in the path of include directory
COPY --from=rubylang/ruby:3.0.1-focal \
     /usr/local/include/ruby-3.0.0/ \
     /usr/local/include/ruby-3.0.0/

COPY --from=rubylang/ruby:3.0.1-focal \
     /usr/local/lib/libruby.so \
     /usr/local/lib/libruby.so.* \
     /usr/local/lib/

COPY --from=rubylang/ruby:3.0.1-focal \
     /usr/local/lib/pkgconfig/ \
     /usr/local/lib/pkgconfig/

COPY --from=rubylang/ruby:3.0.1-focal \
     /usr/local/lib/ruby/ \
     /usr/local/lib/ruby/

COPY --from=rubylang/ruby:3.0.1-focal \
     /usr/local/share/man/man1/erb.1 \
     /usr/local/share/man/man1/irb.1 \
     /usr/local/share/man/man1/ri.1 \
     /usr/local/share/man/man1/ruby.1 \
     /usr/local/share/man/man1/

USER $NB_UID

RUN echo "gem: --user-install" >> $HOME/.gemrc

# NOTE: DO NOT CHANGE the version in the path of gem's bin directory
ENV PATH $HOME/.local/share/gem/ruby/3.0.0/bin:$PATH

# Install basic gems
RUN gem install \
        activerecord \
        awesome_print \
        charty \
        daru \
        daru-view \
        ffi-rzmq \
        iruby \
        matplotlib \
        mysql2 \
        nmatrix \
        nmatrix-lapacke \
        numpy \
        numo-narray \
        numo-linalg \
        pandas \
        pg \
        pry \
        pry-doc \
        pycall \
        rbplotly \
        red-arrow \
        red-arrow-numo-narray \
        red-arrow-nmatrix \
        red-chainer \
        red-datasets \
        red-datasets-arrow \
        red-datasets-daru \
        red-gandiva \
        red-parquet \
        red-plasma \
        rumale \
        sqlite3

RUN iruby register
