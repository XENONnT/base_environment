# base_environment

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.5555410.svg)](https://doi.org/10.5281/zenodo.5555410)
[![Test and update contexts](https://github.com/XENONnT/base_environment/actions/workflows/test_and_update.yml/badge.svg)](https://github.com/XENONnT/base_environment/actions/workflows/test_and_update.yml)

Base software environment for XENONnT, including Python 3 and data management tools.

Please see [this page on the XENON wiki](https://xe1t-wiki.lngs.infn.it/doku.php?id=xenon%3Axenonnt%3Acomputing%3Abaseenvironment) for more details.

The resulting environment is available as:

* **Singularity image under CVMFS.** This can be used in interactive enviroments as well as OSG compute jobs
  The location is `/cvmfs/singularity.opensciencegrid.org/opensciencegrid/osgvo-xenon:{version}`. Source
  `/opt/XENONnT/setup.sh` to get the environment configured.
* **Source-able environment under CVMFS.** This is mostly useful in interactive enviroments like Midway. Note
  that it assumes you are on a EL7 based host. The location is
  `/cvmfs/xenon.opensciencegrid.org/releases/nT/{version}` and each version contains a `setup.sh` script
  you can source to get the environment.
* **Docker image in DockerHub**. This version can be useful if you want to extend the base_environment, or
  use the environment for example on your laptop. The location is `opensciencegrid/osgvo-xenon:{version}`
* **Singularity images available on https**. This version is experimental. The
  location is `https://xenon.isi.edu/images/`
  
## master and stable branches
Currently, the master branch is used for the "development" container, which always points to the master branch of cutax (note this only matters on hardcoded sites: Midway and the OSG login node for now). The stable branch has a tagged version of cutax.

## Deployment

![Deployment Overview](https://raw.githubusercontent.com/XENONnT/base_environment/master/images/deployment.png)

The base_environment is rebuilt and redeployed automatically upon git commits. Just like in
XENON1T, we have a `create-env` script which does the majority of the work. The difference
in XENONnT is that the `create-env` script is run in a Docker container. The build is 
taking place twice: once to build the Docker container with a deployment under
`/opt/XENONnT`, and once to build the tarball for the CVMFS deployment under
`/cvmfs/xenon.opensciencegrid.org/releases/nT/`.





