#!/bin/bash

cat << EOF > runCondorBase_${1%.*}.sh
#!/bin/bash

filename=\`basename \${1}\`
process=\${filename%.*}

__conda_setup="$('/home/jyshin/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/jyshin/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/jyshin/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/jyshin/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup


$(echo 'EOF')

if [ ! -d condorBaseOut ]; then mkdir condorBaseOut; fi

python /x4/cms/jyshin/HDT_Classification/Baseline_Selection_v4.py \${1} -o \${process}

mv *.npy condorBaseOut/
EOF

chmod +x runCondorBase_${1%.*}.sh

cat << EOF > job_${1%.*}.jdl
executable = runCondorBase_${1%.*}.sh
universe = vanilla
output   = condorBaseLog/condorBaseLog.log
error    = condorBaseLog/condorBaseErr.err
log      = /dev/null
getenv = True
should_transfer_files = yes
when_to_transfer_output = ON_EXIT
transfer_output_files = condorBaseOut
arguments = \$(DATAFile) 
queue DATAFile from ${1}
EOF
if [ ! -d condorBaseLog ]; then mkdir condorBaseLog; fi

condor_submit job_${1%.*}.jdl

