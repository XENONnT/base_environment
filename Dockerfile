FROM hub.opensciencegrid.org/htc/rocky:9

LABEL opensciencegrid.name="XENONnT"
LABEL opensciencegrid.description="Base software environment for XENONnT, including Python 3.10 and data management tools"
LABEL opensciencegrid.url="http://www.xenon1t.org/"
LABEL opensciencegrid.category="Project"
LABEL opensciencegrid.definition_url="https://github.com/XENONnT/base_environment"

ARG XENONnT_TAG
ENV CONDA_OVERRIDE_GLIBC=2.36

RUN echo "Building Docker container for XENONnT_${XENONnT_TAG} ..."

RUN yum-config-manager --disable Pegasus

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
    yum clean all && \
    localedef -i en_US -f UTF-8 en_US.UTF-8

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
