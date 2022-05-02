ARG BASE_IMAGE_TAG=81a93d20ba4d
FROM jupyter/scipy-notebook:$BASE_IMAGE_TAG

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
        libarrow-dataset-dev \
        libarrow-flight-dev \
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

# Copy Ruby 3.0.2 from rubylang/ruby

COPY --from=rubylang/ruby:3.0.2-focal \
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

COPY --from=rubylang/ruby:3.0.2-focal \
     /usr/local/etc/gemrc \
     /usr/local/etc/

# NOTE: DO NOT CHANGE the version in the path of include directory
COPY --from=rubylang/ruby:3.0.2-focal \
     /usr/local/include/ruby-3.0.0/ \
     /usr/local/include/ruby-3.0.0/

COPY --from=rubylang/ruby:3.0.2-focal \
     /usr/local/lib/libruby.so \
     /usr/local/lib/libruby.so.* \
     /usr/local/lib/

COPY --from=rubylang/ruby:3.0.2-focal \
     /usr/local/lib/pkgconfig/ \
     /usr/local/lib/pkgconfig/

COPY --from=rubylang/ruby:3.0.2-focal \
     /usr/local/lib/ruby/ \
     /usr/local/lib/ruby/

COPY --from=rubylang/ruby:3.0.2-focal \
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
RUN \
    gem install irb -v ">= 1.3.8.pre.9" && \
    gem install iruby -v ">= 0.7.4" && \
    gem install pycall -v ">= 1.4.1" && \
    gem install numpy -v ">= 0.4.0" && \
    gem install matplotlib -v ">= 1.2.0" && \
    gem install pandas -v ">= 0.3.8" && \
    gem install charty -v ">= 0.2.11" && \
    gem install red-datasets -v ">= 0.1.4" && \
    gem install unicode_plot -v ">= 0.0.5" && \
    \
    gem install \
        activerecord \
        awesome_print \
        daru \
        daru-view \
        enumerable-statistics \
        ffi-rzmq \
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
        rbplotly \
        red-arrow \
        red-arrow-numo-narray \
        red-arrow-nmatrix \
        red-chainer \
        red-datasets-arrow \
        red-datasets-daru \
        red-datasets-pandas \
        red-gandiva \
        red-parquet \
        red-plasma \
        rumale \
        sqlite3

RUN iruby register --force
