Bash shell script for HTCondor submit

condor_run.sh --> submit your  MadGraph5 gridpack

run_delphes.sh --> Make list of lhe files and submit
                   It will run delphes3 for the lhe files
				   delphes_sub.sh required.

do_base.sh  --> baseline selection for ttx processes. It will return .npy files after baseline selection. python file for baseline selection and list of root files to do baseline selection are required.
