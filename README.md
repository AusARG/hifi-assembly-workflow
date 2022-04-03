# HiFi Genome assembly using IPA

HiFi-assembly-workflow is a bioinformatics pipeline that can be used to analyse Pacbio CCS reads for denovo genome assembly using PacBio Circular Consensus Sequencing (CCS)  reads. This workflow is implemented in Nextflow and has 3 major sections. 
 
Please refer to the following documentation for detailed description of each workflow section:
 
Pre-assembly quality control (QC)
Assembly 
Post-assembly QC

## HiFi assembly workflow flowchart

![flow chart ](workflow.png?raw=true "HiFi assembly workflow flowchart")


# Quick Usage:
The pipeline has been tested  on NCI Gadi and AGRF balder cluster. If needed to run on AGRF cluster, please contact us at bioinformatics@agrf.org.au.
Please note for running this on NCI Gadi you need access. Please refer to Gadi guidelines for account creation and usage: these can be found at https://opus.nci.org.au/display/Help/Access.

Here is an example that can be used to run a phased assembly on Gadi:
```

Module load nextflow/21.04.3
nextflow run Hifi_assembly.nf –bam_folder <PATH TO THE BAM FOLDER> -profile gadi 
The workflow accepts 2 mandatory arguments:
--bam_folder     --    Full Path to the CCS bam files
-profile         --    gadi/balder/local
```

Please note that you can either run jobs interactively or submit jobs to the cluster. This is determined by the -profile flag. By passing the gadi tag to the profile argument, the jobs are submitted and run on the cluster.


## Example local profile usage
```
Start a screen, submit a job, and run the workflow 
Screen -S ‘name’

qsub -I -qnormal -Pwz54 -lwalltime=48:00:00,ncpus=4,mem=200GB,storage=scratch/wz54+gdata/wz54,wd
export MODULEPATH=/apps/Modules/modulefiles:/g/data/wz54/groupResources/modules

module load nextflow/21.04.3
nextflow run /g/data/wz54/groupResources/scripts/pl/hifi_assembly.nf  --bam_folder  <bam-folder_path> -profile local


This load the scripts directory to the environmental PATH and load nextflow module
module load hifi_assembly/1.0.0 
```

# Outputs

Pipeline generates various files and folders here is a brief description: 
The pipeline creates a folder called “secondary_analysis” that contains two sub folders named 
exeReport     
Results        -- Contains preQC, assembly and postQC analysis files

## exeReport
This folder contains a computation resource usage summary in various charts and a text file. 
“report.html” provides a comprehensive summary.

## Results
The ‘Results’ folder contains three sub-directories preQC, assembly and postqc. As the name suggests, outputs from the respective workflow sections are placed in each of these folders.

### preQC
The following table contains list of files and folder from preQC results

| Output folder/file | File             | Description                                                                    |
| ------------------ | ---------------- | ------------------------------------------------------------------------------ |
| <sample>.fa        |                  | Bam files converted to fasta format                                            |
| kmer\_analysis     |                  | Folder containing kmer analysis outputs                                        |
|                    | <sample>.jf      | k-mer counts from each sample                                                  |
|                    | <sample>.histo   | histogram of k-mer occurrence                                                  |
| genome\_profiling  |                  | genomescope profiling outputs                                                  |
|                    | summary.txt      | Summary metrics of genome scope outputs                                        |
|                    | linear\_plot.png | Plot showing no. of times a k-mer observed by no. of k-mers with that coverage |


### Assembly
This folder contains final assembly results in <FASTA> format.
<sample>_primary.fa    - Fasta file containing primary contigs
<sample>_associate.fa    - Fasta file containing associated contigs

### postqc
The postqc folder contains two sub folders 
assembly_completeness
assembly_evaluation
assembly_completeness
This contains BUSCO evaluation results for primary and associate contig.

### assembly_evaluation
Assembly evaluation folder contains various file formats, here is a brief description for each of the outputs.

| File        | Description                                                                               |
| ----------- | ----------------------------------------------------------------------------------------- |
| report.txt  | Assessment summary in plain text format                                                   |
| report.tsv  | Tab-separated version of the summary, suitable for spreadsheets (Google Docs, Excel, etc) |
| report.tex  | LaTeX version of the summary                                                              |
| icarus.html | Icarus main menu with links to interactive viewers                                        |
| report.html | HTML version of the report with interactive plots inside                                  |


# Infrastructure usage and recommendations

### NCI facility access
One should have a user account set with NCI to access gadi high performance computational facility. Setting up a NCI account is mentioned in detail at the following URL: https://opus.nci.org.au/display/Help/Setting+up+your+NCI+Account 
  
Documentation for a specific infrastructure should go into a infrastructure documentation template
https://github.com/AustralianBioCommons/doc_guidelines/blob/master/infrastructure_optimisation.md


## Compute resource usage across tested infrastructures

|                                       | Computational resource for plant case study |
| ------------------------------------- | ------------------------------------------- |
|                                       | Time                                        | CPU | Memory | I/O |
| Process                               | duration                                    | realtime | %cpu | peak\_rss | peak\_vmem | rchar | wchar |
| Converting bam to fasta for sample    | 12m 54s                                     | 12m 48s | 99.80% | 5.2 MB | 197.7 MB | 43.3 GB | 50.1 GB |
| Generating k-mer counts and histogram | 26m 43s                                     | 26m 36s | 1725.30% | 19.5 GB | 21 GB | 77.2 GB | 27.1 GB |
| Profiling genome characteristics      | 34.7s                                       | 13.2s | 89.00% | 135 MB | 601.2 MB | 8.5 MB | 845.9 KB |
| Denovo assembly                       | 6h 51m 15s                                  | 6h 51m 11s | 4744.40% | 84.7 GB | 225.6 GB | 1.4 TB | 456 GB |
| evaluate\_assemblies                  | 5m 18s                                      | 4m 54s | 98.20% | 1.6 GB | 1.9 GB | 13.6 GB | 2.8 GB |
| assemblies\_completeness              | 25m 57s                                     | 25m 53s | 2624.20% | 22 GB | 25.2 GB | 624.9 GB | 2.9 GB |


|                                       | Computational resource for bird case study |
| ------------------------------------- | ------------------------------------------ |
|                                       | Time                                       | CPU | Memory | I/O |
| Process                               | duration                                   | realtime | %cpu | peak\_rss | peak\_vmem | rchar | wchar |
| Converting bam to fasta for sample    | 12m 54s                                    | 7m 9s | 86.40% | 5.2 MB | 197.8 MB | 21.5 GB | 27.4 GB |
| Generating k-mer counts and histogram | 26m 43s                                    | 15m 34s | 1687.70% | 10.1 GB | 11.7 GB | 44 GB | 16.6 GB |
| Profiling genome characteristics      | 34.7s                                      | 1m 15s | 15.30% | 181.7 MB | 562.2 MB | 8.5 MB | 819.1 KB |
| De novo assembly                      | 6h 51m 15s                                 | 9h 2m 47s | 1853.50% | 67.3 GB | 98.4 GB | 1 TB | 395.6 GB |
| evaluate assemblies                   | 5m 18s                                     | 2m 48s | 97.50% | 1.1 GB | 1.4 GB | 8.7 GB | 1.8 GB |
| assemblies completeness               | 25m 57s                                    | 22m 36s | 2144.00% | 22.2 GB | 25 GB | 389.7 GB | 1.4 GB |


# Workflow summaries

## Metadata

| Metadata field   | Pre-assembly quality control                                                      | Primary assembly   | Post-assembly quality control |
| ---------------- | --------------------------------------------------------------------------------- | ------------------ | ----------------------------- |
| Version          | 1.0                                                                               | 1.0                | 1.0                           |
| Maturity         | Production                                                                        | Production         | production                    |
| Creators         | Naga, Kenneth                                                                     | Naga, Kenneth      | Naga, Kenneth                 |
| Source           | [AusARG/hifi-assembly-workflow](https://github.com/AusARG/hifi-assembly-workflow) |
| License          |                                                                                   |                    |                               |
| Workflow manager | NextFlow                                                                          | NextFlow           | NextFlow                      |
| Container        | No containers used                                                                | No containers used | No containers used            |
| Install method   | Manual                                                                            | Manual             | Manual                        |


## Component tools
​
| Workflow element                  | Workflow element version | Workflow title                |
| --------------------------------- | ------------------------ | ----------------------------- |
| Samtools, jellyfish, genomescope  | 1.0                      | Pre-assembly quality control  |
| Improved phased assembler (pbipa) | 1.0                      | Primary assembly              |
| Quast and busco                   | 1.0                      | Post-assembly quality control |


## Required (minimum) inputs/parameters
​ 
 PATH to HIFI bam folder is the minimum requirement for the processing the pipeline

​
## Third party tools / dependencies
​
​The following packages are used by the pipeline.
nextflow/21.04.3
samtools/1.12
jellyfish/2.3.0
genomescope/2.0
ipa/1.3.1
quast/5.0.2
busco/5.2.2

The following paths contain all modules required for the pipeline.
/apps/Modules/modulefiles 
/g/data/wz54/groupResources/modules 



---

# General recommendations 

A more detailed Module and workflow descriptions are made avaiable 
- [Workflow description](workflows.md)

---

# Resources available here

This repository contains structured documentation for [dependencies and usage], including links to existing repositories and community resources, as well as a description of the optimisations achieved on the following compute systems:

- [dependencies and usage](infrastructure_optimisation.md)
- ...

---

# Attributions

The guideline template is supported by the Australian BioCommons via Bioplatforms Australia funding, the Australian Research Data Commons (https://doi.org/10.47486/PL105) and the Queensland Government RICF programme. Bioplatforms Australia and the Australian Research Data Commons are enabled by the National Collaborative Research Infrastructure Strategy (NCRIS).

The BioCommons would also like to acknowledge the contributions of the following individuals and institutions to these documentation guidelines:

- Johan Gustafsson (Australian BioCommons, University of Melbourne) [@supernord](https://github.com/supernord)
- Brian Davis (National Computational Infrastructure) [@Davisclan](https://github.com/Davisclan)
- Marco de la Pierre (Pawsey Supercomputing Centre) [@marcodelapierre](https://github.com/marcodelapierre)
- Audrey Stott (Pawsey Supercomputing Centre) [@audreystott](https://github.com/audreystott)
- Sarah Beecroft (Pawsey Supercomputing Centre) [@SarahBeecroft](https://github.com/SarahBeecroft)
- Matthew Downton (National Computational Infrastructure) [@mattdton](https://github.com/mattdton)
- Richard Edwards (University of New South Wales) [@cabbagesofdoom](https://github.com/cabbagesofdoom)
- Tracy Chew (University of Sydney) [@tracychew](https://github.com/tracychew)
- Georgina Samaha (University of Sydney) [@georgiesamaha](https://github.com/georgiesamaha)



