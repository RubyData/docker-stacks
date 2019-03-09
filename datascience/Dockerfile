ARG BASE_IMAGE_TAG=7db1bd2a7511
FROM jupyter/datascience-notebook:$BASE_IMAGE_TAG

LABEL maintainer="Kenta Murata <mrkn@mrkn.jp>"

USER root

# Pre-requisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
            ca-certificates \
            gcc \
            libczmq-dev \
            libffi-dev \
            libgdbm-dev \
            libgmp-dev \
            libncurses5-dev \
            libopenblas-dev \
            libreadline-dev \
            libsqlite3-dev \
            libssl-dev \
            libxml2-dev \
            libxslt1-dev \
            libyaml-dev \
            libzmq3-dev \
            sqlite3 \
            tzdata \
            zlib1g-dev && \
    rm -rf /var/lib/apt/lists/*

# Copy Ruby 2.6.2 from rubylang/ruby

COPY --from=rubylang/ruby:2.6.2-bionic \
     /usr/local/bin/bundle \
     /usr/local/bin/bundler \
     /usr/local/bin/erb \
     /usr/local/bin/gem \
     /usr/local/bin/irb \
     /usr/local/bin/rake \
     /usr/local/bin/rdoc \
     /usr/local/bin/ri \
     /usr/local/bin/ruby \
     /usr/local/bin/

COPY --from=rubylang/ruby:2.6.2-bionic \
     /usr/local/etc/gemrc \
     /usr/local/etc/

COPY --from=rubylang/ruby:2.6.2-bionic \
     /usr/local/include/ruby-2.6.0/ \
     /usr/local/include/ruby-2.6.0/

COPY --from=rubylang/ruby:2.6.2-bionic \
     /usr/local/lib/libruby.so \
     /usr/local/lib/libruby.so.* \
     /usr/local/lib/pkgconfig \
     /usr/local/lib/

COPY --from=rubylang/ruby:2.6.2-bionic \
     /usr/local/lib/ruby/ \
     /usr/local/lib/ruby/

COPY --from=rubylang/ruby:2.6.2-bionic \
     /usr/local/share/man/man1/bundle-*.1 \
     /usr/local/share/man/man1/bundle.1 \
     /usr/local/share/man/man1/erb.1 \
     /usr/local/share/man/man1/irb.1 \
     /usr/local/share/man/man1/ri.1 \
     /usr/local/share/man/man1/ruby.1 \
     /usr/local/share/man/man1/

COPY --from=rubylang/ruby:2.6.2-bionic \
     /usr/local/share/man/man5/gemfile.5 \
     /usr/local/share/man/man5/

USER $NB_UID

RUN echo "gem: --user-install" >> $HOME/.gemrc

ENV PATH $HOME/.gem/ruby/2.6.0/bin:$PATH

RUN gem install \
        iruby \
        ffi-rzmq \
        daru \
        numo-narray \
        numo-linalg \
        pycall \
        numpy \
        pandas \
        matplotlib \
    \
    && iruby register
