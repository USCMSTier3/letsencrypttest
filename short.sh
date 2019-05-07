#!/bin/bash 
# short.sh: a short discovery job 

#/usr/libexec/condor/condor_chirp write myfile1 _condor_stdout

printf "Start time: "; /bin/date 
printf "Job is running on node: "; /bin/hostname 
printf "Job running as user: "; /usr/bin/id 
printf "Job is running in directory: "; /bin/pwd 

echo "SO version"
cat /etc/issue
cat /etc/redhat-release

echo "CVMFS->local"
ls -l /cvmfs/cms.cern.ch/SITECONF/local

echo "singularity version"
singularity --version

echo -e "\n\n"
echo "-----------XRootD tests-------------"
printf "xrdcopy location: "; which xrdcopy 2>&1
#source  /cvmfs/oasis.opensciencegrid.org/mis/osg-wn-client/3.3/current/el6-x86_64/setup.sh
echo "@@@First test in debug mode@@@"
echo `date`" xrdcopy -f root://hepxrd01.colorado.edu:1094//store/test/xrootd/T3_US_Colorado/store/mc/SAM/GenericTTbar/AODSIM/CMSSW_9_2_6_91X_mcRun1_realistic_v2-v1/00000/A64CCCF2-5C76-E711-B359-0CC47A78A3F8.root"
xrdcopy --debug 2 -f root://hepxrd01.colorado.edu:1094//store/test/xrootd/T3_US_Colorado/store/mc/SAM/GenericTTbar/AODSIM/CMSSW_9_2_6_91X_mcRun1_realistic_v2-v1/00000/A64CCCF2-5C76-E711-B359-0CC47A78A3F8.root file://$PWD/TestColorado.root 2>&1
echo -e "exit code: $? \n"

echo -e \n\n"@@@Second test"
echo `date`" xrdcopy -f root://hepxrd01.colorado.edu:1094//store/mc/SAM/GenericTTbar/AODSIM/CMSSW_9_2_6_91X_mcRun1_realistic_v2-v1/00000/A64CCCF2-5C76-E711-B359-0CC47A78A3F8.root file://$PWD/TestColorado.root"
xrdcopy -f root://hepxrd01.colorado.edu:1094//store/mc/SAM/GenericTTbar/AODSIM/CMSSW_9_2_6_91X_mcRun1_realistic_v2-v1/00000/A64CCCF2-5C76-E711-B359-0CC47A78A3F8.root file://$PWD/TestColorado.root 2>&1
echo -e "exit code: $? \n"

echo -e \n\n"@@@Third test"
echo `date`" xrdcopy -f /store/user/johnsond/gridftp-probe-test-file.1392772080.29006.remote"
xrdcopy -f root://cms-xrd-global.cern.ch//store/user/johnsond/gridftp-probe-test-file.1392772080.29006.remote file:///tmp/TestColorado.root 2>&1
echo -e "exit code: $? \n"
echo "-----------end of XRootD tests-------------"
echo -e "\n\n"


echo "----------GFAL-COPY tests to XRootD Server (via xrd plugin)---------"
printf "gfal-copy location: "; which gfal-copy 2>&1
echo "@@@First test in verbose mode@@@"
echo `date`"gfal-copy -vvv -f root://hepxrd01.colorado.edu:1094//store/test/xrootd/T3_US_Colorado/store/mc/SAM/GenericTTbar/AODSIM/CMSSW_9_2_6_91X_mcRun1_realistic_v2-v1/00000/A64CCCF2-5C76-E711-B359-0CC47A78A3F8.root $PWD/TestColorado.root"
gfal-copy -vvv -f root://hepxrd01.colorado.edu:1094//store/test/xrootd/T3_US_Colorado/store/mc/SAM/GenericTTbar/AODSIM/CMSSW_9_2_6_91X_mcRun1_realistic_v2-v1/00000/A64CCCF2-5C76-E711-B359-0CC47A78A3F8.root $PWD/TestColorado.root 2>&1
echo -e "exit code: $? \n"
echo -e \n\n"@@@Second test"
echo `date`"gfal-copy -f root://hepxrd01.colorado.edu:1094//store/mc/SAM/GenericTTbar/AODSIM/CMSSW_9_2_6_91X_mcRun1_realistic_v2-v1/00000/A64CCCF2-5C76-E711-B359-0CC47A78A3F8.root"
gfal-copy -f root://hepxrd01.colorado.edu:1094//store/mc/SAM/GenericTTbar/AODSIM/CMSSW_9_2_6_91X_mcRun1_realistic_v2-v1/00000/A64CCCF2-5C76-E711-B359-0CC47A78A3F8.root $PWD/TestColorado.root 2>&1
echo -e "exit code: $? \n"

echo -e \n\n"@@@Third test"
echo `date`"gfal-copy -f root://cms-xrd-global.cern.ch//store/user/johnsond/gridftp-probe-test-file.1392772080.29006.remote"
gfal-copy -f root://cms-xrd-global.cern.ch//store/user/johnsond/gridftp-probe-test-file.1392772080.29006.remote TestColorado.root 2>&1
echo -e "exit code: $? \n"

echo -e "\n\n"
echo "----------GFAL-COPY tests to GSIFTP Server---------"
echo `date`"gfal-ls -vvv gsiftp://gridftp-hadoop.colorado.edu/mnt/hadoop/store"
gfal-ls -vvv gsiftp://gridftp-hadoop.colorado.edu/mnt/hadoop/store 2>&1
echo -e "exit code: $? \n"
echo "----------end of GFAL-COPY tests---------"

echo -e "-----Print environment------\n"
# Now, show env
env
echo -e "---------environment--------\n\n"

if [ -e "$PWD/TestColorado.root" ]; then
    rm $PWD/TestColorado.root
fi

echo "All done"
