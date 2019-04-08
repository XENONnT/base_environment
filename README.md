# base_environment

Base software environment for XENONnT, including py3.6 and data management tools.

`create-env` can be used to create a software install on a EL7 system.
As external dependencies can be difficult to satisfy on some compute
nodes, we also use the `Dockerfile` to generate a Docker image which is
then automatically synced to the OSG Singularity CVMFS repository. The 
resulting image can be found in the Docker Hub at 
[https://hub.docker.com/r/opensciencegrid/osgvo-xenon](https://hub.docker.com/r/opensciencegrid/osgvo-xenon)
and in CVMFS at:

    /cvmfs/singularity.opensciencegrid.org/opensciencegrid/osgvo-xenon:latest

and explored via an interactive Singularity shell session:

    singularity shell /cvmfs/singularity.opensciencegrid.org/opensciencegrid/osgvo-xenon:latest

