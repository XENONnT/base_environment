# base_environment

[![Build Status](https://travis-ci.org/XENONnT/base_environment.svg?branch=master)](https://travis-ci.org/XENONnT/base_environment)
[![Updates](https://pyup.io/repos/github/XENONnT/base_environment/shield.svg)](https://pyup.io/repos/github/XENONnT/base_environment/)

Base software environment for XENONnT, including py3.6 and data management tools.

Please see [https://xe1t-wiki.lngs.infn.it/doku.php?id=xenon:xenonnt:computing:baseenvironment](https://xe1t-wiki.lngs.infn.it/doku.php?id=xenon:xenonnt:computing:baseenvironment)

The resulting environement is available as:

* **Singularity image under CVMFS.** This can be used in interactive enviroments as well as OSG compute jobs
  The location is `/cvmfs/singularity.opensciencegrid.org/opensciencegrid/osgvo-xenon:{version}`. Source
  `/opt/XENONnT/setup.sh` to get the environment configured.
* **Source-able environment under CVMFS.** This is mostly useful in interactive enviroments like Midway. Note
  that it assumes you are on a EL7 based host. The location is
  `/cvmfs/xenon.opensciencegrid.org/releases/nT/{version}` and each version contains a `setup.sh` script
  you can source to get the environment.
* **Docker image in DockerHub**. This version can be useful if you want to extend the base_environment, or
  use the environment for example on your laptop. The location is `opensciencegrid/osgvo-xenon:{version}`

## Deployment

![Deployment Overview](https://raw.githubusercontent.com/XENONnT/base_environment/master/images/deployment.png)

The base_environment is rebuilt and redeployed automatically upon git commits. Just like in
XENON1T, we have a `create-env` script which does the majority of the work. The difference
in XENONnT is that the `create-env` script is run in a Docker container. The build is 
taking place twice: once to build the Docker container with a deployment under
`/opt/XENONnT`, and once to build the tarball for the CVMFS deployment under
`/cvmfs/xenon.opensciencegrid.org/releases/nT/`.




