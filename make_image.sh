#!/bin/bash

cat << EOF > runCondorIm_${1%.*}.sh
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

if [ ! -d condorImOut ]; then mkdir condorImOut; fi

python /x4/cms/jyshin/HDT_Classification/make_image_v2.py \${1} -o \${process}

mv *.h5 condorImOut/
EOF

chmod +x runCondorIm_${1%.*}.sh

cat << EOF > job_${1%.*}.jdl
executable = runCondorIm_${1%.*}.sh
universe = vanilla
output   = condorImLog/condorImLog.log
error    = condorImLog/condorImErr.err
log      = /dev/null
getenv = True
should_transfer_files = yes
when_to_transfer_output = ON_EXIT
transfer_output_files = condorImOut
requirements = (machine == "node01")||(machine == "node02")||(machine == "node03")||(machine == "node04")||(machine=="node05")
arguments = \$(DATAFile) 
queue DATAFile from ${1}
EOF
if [ ! -d condorImLog ]; then mkdir condorImLog; fi

condor_submit job_${1%.*}.jdl

