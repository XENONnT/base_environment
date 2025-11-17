FROM hub.opensciencegrid.org/htc/centos:7

LABEL opensciencegrid.name="XENONnT"
LABEL opensciencegrid.description="Base software environment for XENONnT EL7 (Python 3.9)"
LABEL opensciencegrid.url="http://www.xenon1t.org/"
LABEL opensciencegrid.category="Project"
LABEL opensciencegrid.definition_url="https://github.com/XENONnT/base_environment"

ARG XENONnT_TAG
ENV CONDA_OVERRIDE_GLIBC=2.36

RUN echo "Building Docker container for XENONnT_${XENONnT_TAG} ..."

# 1) Disable Pegasus repo (as usual)
RUN yum-config-manager --disable Pegasus

# 2) Fix CentOS7 EOL: force all repos to use vault.centos.org
RUN sed -i 's|mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/CentOS-* && \
    sed -i 's|#baseurl=http://mirror.centos.org/centos|baseurl=http://vault.centos.org/centos|g' /etc/yum.repos.d/CentOS-* && \
    sed -i 's|#baseurl=http://vault.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

# 3) Now upgrading works
RUN yum -y clean all && yum -y --skip-broken upgrade

# 4) Install SCL + required dev packages
RUN yum -y install centos-release-scl && \
    yum -y install \
        cmake \
        davix-devel \
        dcap-devel \
        devtoolset-9 \
        doxygen \
        dpm-devel \
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
        lfc-devel \
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
        bash-completion-extras && \
    yum clean all && \
    localedef -i en_US -f UTF-8 en_US.UTF-8

ADD create-env conda_xnt.yml requirements.txt /tmp/
COPY extra_requirements/requirements-tests.txt /tmp/extra_requirements/requirements-tests.txt

RUN source /opt/rh/devtoolset-9/enable && \
    cd /tmp && \
    bash create-env /opt/XENONnT ${XENONnT_TAG} && \
    rm -f create-env conda_xnt.yml

# relax permissions so we can build CVMFS tarballs
RUN mkdir -p /cvmfs && chmod 1777 /cvmfs

COPY labels.json /.singularity.d/

RUN echo "Timestamp:" `date --utc` | tee /image-build-info.txt
