HiFi Assembly workflow on NCI gadi
===========

---

# Accessing tool/workflow

Pipeline consists of mainly three modules. 
1.	Preqc consist of bam to fasta conversion, k-mer analysis and genome profiling processes.
2.	Assembly module consists of processing CCS data using IPA
3.	Post assembly module consists of assembly evaluation and assessing completeness.


Dependencies:

The following packages are used by the pipeline.
```
nextflow/21.04.3
samtools/1.12
jellyfish/2.3.0
genomescope/2.0
ipa/1.3.1
quast/5.0.2
busco/5.2.2
```
The following paths contains all modules required for the pipeline.
```
/apps/Modules/modulefiles 
/g/data/wz54/groupResources/modules 
```

# Quickstart tutorial

login to gadi with you credientails and set module path variable

In case, quick usage described on README.md didn't work on your environment. You can try the following:

Set MODULEPATH 
```
MODULEPATH=/apps/Modules/modulefiles:/g/data/wz54/groupResources/modules:/g/data/if89/apps/modulefiles:/etc/scl/modulefiles:/opt/Modules/modulefiles:/opt/Modules/v4.3.0/modulefiles

export MODULEPATH
```

export scripts to the PATH variable
```
PATH=$PATH:/g/data/wz54/groupResources/scripts/hifi-assembly-workflow
```

This workflow can be run on NCI gadi or on AGRF balder

Submitting jobs to gadi cluster
```
hifi_assembly.nf --bam_folder <PATH_TO_BAM_FOLDER> -profile gadi
```


# Acknowledgements / citations / credits

```
Any attribution information that is relevant to the workflow being documented, or the infrastructure being used.
```

---
