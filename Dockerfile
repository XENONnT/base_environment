FROM hub.opensciencegrid.org/htc/rocky:8

LABEL opensciencegrid.name="XENONnT"
LABEL opensciencegrid.description="Base software environment for XENONnT, including Python 3.11 and data management tools"
LABEL opensciencegrid.url="http://www.xenon1t.org/"
LABEL opensciencegrid.category="Project"
LABEL opensciencegrid.definition_url="https://github.com/XENONnT/base_environment"

ARG XENONnT_TAG
ENV CONDA_OVERRIDE_GLIBC=2.36

RUN echo "Building Docker container for XENONnT_${XENONnT_TAG} ..."

RUN dnf -y config-manager --set-disabled Pegasus

RUN dnf -y clean all && dnf -y --skip-broken upgrade

RUN dnf -y install \
            cmake \
            davix-devel \
            dcap-devel \
            doxygen \
            gfal2-all \
            gfal2-devel \
            gfal2-plugin-file \
            gfal2-plugin-gridftp \
            gfal2-plugin-http \
            gfal2-plugin-sftp \
            gfal2-plugin-srm \
            gfal2-plugin-xrootd \
            glib2-devel \
            globus-gass-copy-devel \
            graphviz \
            gtest-devel \
            json-c-devel \
            libarchive \
            libattr-devel \
            libffi-devel \
            libssh2-devel \
            libuuid-devel \
            openldap-devel \
            srm-ifce-devel \
            xrootd-client-devel \
            zlib-devel \
            nano \
            bash-completion \
    && \
    dnf clean all && \
    localedef -i en_US -f UTF-8 en_US.UTF-8


RUN    rpm --import http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-Official

RUN    yum install -y \
           cmake \
           curl \
	   diffutils \
           ghostscript \
           gpg \
           make \
           unzip \
           zip

RUN    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64" \
    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64.asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu

RUN    rpm --import "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xD6BC243565B2087BC3F897C9277A7293F59E4889" \
    && curl -L -o /etc/yum.repos.d/miktex.repo https://miktex.org/download/centos/8/miktex.repo \
    && dnf -y install miktex

RUN    miktexsetup finish \
    && initexmf --admin --set-config-value=[MPM]AutoInstall=1 \
    && mpm --admin --update-db \
    && mpm --admin \
           --install amsfonts \
           --install biber-linux-x86_64 \
    && initexmf --admin --update-fndb


ENV MIKTEX_USERCONFIG=/miktex/.miktex/texmfs/config
ENV MIKTEX_USERDATA=/miktex/.miktex/texmfs/data
ENV MIKTEX_USERINSTALL=/miktex/.miktex/texmfs/install

WORKDIR /miktex/work

ADD create-env conda_xnt.yml requirements.txt /tmp/

COPY extra_requirements/requirements-tests.txt /tmp/extra_requirements/requirements-tests.txt

RUN cd /tmp && \
    bash create-env /opt/XENONnT ${XENONnT_TAG} && \
    rm -f create-env conda_xnt.yml

# relax permissions so we can build cvmfs tar balls
RUN mkdir -p /cvmfs && chmod 1777 /cvmfs

COPY labels.json /.singularity.d/


# build info
RUN echo "Timestamp:" `date --utc` | tee /image-build-info.txt
