HiFi Assembly workflow on NCI gadi
===========

---

# Accessing tool/workflow

The pipeline consists of three modules.

1.	[Pre-assembly quality control (QC)](https://github.com/AusARG/hifi-assembly-workflow/blob/master/recommendations.md#stage-1-pre-assembly-quality-control) consisting of bam to fasta conversion, k-mer analysis and genome profiling processes.
2.	[Assembly](https://github.com/AusARG/hifi-assembly-workflow/blob/master/recommendations.md#stage-2-assembly) module consists of processing CCS data using [IPA](https://bio.tools/ipa_hifi)
3.	[Post-assembly QC](https://github.com/AusARG/hifi-assembly-workflow/blob/master/recommendations.md#stage-3-post-assembly-quality-control) module consists of assembly evaluation and assessing completeness.

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

1. Login to Gadi with your credentials and set the module path variable

2. In case the quick usage described in the README.md didn't work on your environment, you can try the following:

3. Set MODULEPATH 

```
MODULEPATH=/apps/Modules/modulefiles:/g/data/wz54/groupResources/modules:/g/data/if89/apps/modulefiles:/etc/scl/modulefiles:/opt/Modules/modulefiles:/opt/Modules/v4.3.0/modulefiles

export MODULEPATH
```

4. Export scripts to the PATH variable

```
PATH=$PATH:/g/data/wz54/groupResources/scripts/hifi-assembly-workflow
```

5. This workflow can be run on NCI gadi or on AGRF balder

6. Submit jobs to Gadi

```
hifi_assembly.nf --bam_folder <PATH_TO_BAM_FOLDER> -profile gadi
```


# Acknowledgements / citations / credits

Please see the [README.md attributions section](https://github.com/AusARG/hifi-assembly-workflow#attributions).

---
