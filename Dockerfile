FROM opensciencegrid/osgvo-el7

RUN yum -y upgrade

RUN yum -y install \
            cmake \
            davix-devel \
            dcap-devel \
            doxygen \
            dpm-devel \
            glib2-devel \
            globus-gass-copy-devel \
            gtest-devel \
            json-c-devel \
            lfc-devel \
            libattr-devel \
            libssh2-devel \
            openldap-devel \
            srm-ifce-devel \
            xrootd-client-devel \
            zlib-devel

ADD create-env /tmp/

RUN cd /tmp && \
    bash create-env /opt/XENONnT && \
    rm -f create-env

# mnt points - these are in addition to what exists in osgvo-el7
RUN for MNTPOINT in \
        /scratch \
    ; do \
        mkdir -p $MNTPOINT ; \
    done

# build info
RUN echo "Timestamp:" `date --utc` | tee /image-build-info.txt

