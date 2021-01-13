FROM opensciencegrid/osgvo-el7

LABEL opensciencegrid.name="XENONnT"
LABEL opensciencegrid.description="Base software environment for XENONnT, including Python 3.6 and data management tools"
LABEL opensciencegrid.url="http://www.xenon1t.org/"
LABEL opensciencegrid.category="Project"
LABEL opensciencegrid.definition_url="https://github.com/XENONnT/base_environment"

ARG XENONnT_TAG

RUN echo "Building Docker container for XENONnT_${XENONnT_TAG} ..."

RUN yum -y clean all && yum -y --skip-broken upgrade

RUN  yum -y install centos-release-scl && \
     yum -y install \
            cmake \
            davix-devel \
            dcap-devel \
            devtoolset-9 \
            doxygen \
            dpm-devel \
            gfal2-all \
            gfal2-devel \
            glib2-devel \
            globus-gass-copy-devel \
            gtest-devel \
            json-c-devel \
            lfc-devel \
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
    yum clean all && \
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


