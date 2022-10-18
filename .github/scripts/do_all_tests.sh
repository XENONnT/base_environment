## Source env
. /opt/XENONnT/setup.sh
cd $HOME

for package in strax straxen wfsim pema cutax admix gfal;
do
  echo testing $package;
  bash /home/.github/scripts/do_tests.sh $package;
done
