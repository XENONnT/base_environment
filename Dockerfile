FROM opensciencegrid/osgvo-el8

LABEL opensciencegrid.name="XENONnT"
LABEL opensciencegrid.description="Base software environment for XENONnT, including Python 3.8 and data management tools"
LABEL opensciencegrid.url="http://www.xenon1t.org/"
LABEL opensciencegrid.category="Project"
LABEL opensciencegrid.definition_url="https://github.com/XENONnT/base_environment"

ARG XENONnT_TAG

RUN echo "Building Docker container for XENONnT_base-${XENONnT_TAG} ..."

RUN dnf -y clean all && dnf -y --skip-broken upgrade

RUN  dnf -y group install "Development Tools" && \
     dnf -y install \
            cmake \
            davix-devel \
            dcap-devel \
            gcc-toolset-9-gcc \
            gcc-toolset-9-gcc-c++ \
            doxygen \
            dmlite-devel \
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
            gtest-devel \
            json-c-devel \
            # lfc-devel \
            libattr-devel \
            libffi-devel \
            libssh2-devel \
            libuuid-devel \
            openldap-devel \
            srm-ifce-devel \
            xrootd-client-devel \
            zlib-devel \
            nano \
    && \
    dnf clean all && \
    localedef -i en_US -f UTF-8 en_US.UTF-8

ADD create-env conda_xnt.yml requirements.txt /tmp/

RUN source /opt/rh/devtoolset-9/enable && \
    cd /tmp && \
    bash create-env /opt/XENONnT ${XENONnT_TAG} && \
    rm -f create-env conda_xnt.yml

# relax permissions so we can build cvmfs tar balls
RUN chmod 1777 /cvmfs

COPY labels.json /.singularity.d/

# build info
RUN echo "Timestamp:" `date --utc` | tee /image-build-info.txt


