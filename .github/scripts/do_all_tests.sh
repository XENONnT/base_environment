## Source env
. /opt/XENONnT/setup.sh
cd $HOME

echo 'pwd' `pwd`
echo 'ls' `ls`
echo '/home' `ls /home`
echo '/home/.github' `ls /home/.github`
echo '$HOME' $HOME

# FIXME add XEDOCS
for package in strax straxen wfsim pema cutax admix gfal;
do
  echo testing $package;
  bash .github/scripts/do_tests.sh $package;
done
