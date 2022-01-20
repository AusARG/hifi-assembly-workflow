#!/usr/bin/env nextflow
nextflow.enable.dsl=2

def helpMessage() {
    log.info """
    ====================================
     Denovo HiFi assembly pipeline 
    ====================================
    Usage:
    The typical command for running the pipeline is as follows:
    
    nextflow run hifi_assembly.nf --bam_folder  <HiFi BAM files> 

    Mandatory arguments:
      --bam_folder                 Folder containing BAM files (Only *HiFi* BAM file)

    Optional arguments:
      --out_dir                   Path to the otuput directory. Default: "$param.bam_folder/secondary_analysis"

"""
}

// Show help message
params.help = false
if (params.help) {
    helpMessage()
    exit 0
}

// General configuration variables


if (params.bam_folder) {
    	bamf = params.bam_folder
} else {
   	println("Please provide path to bam files\n")
    	helpMessage()
    	exit 1
}

// If outDir is not defined created 'secondary_analysis' directory 
if (params.out_dir) {
    	outDir = params.out_dir
} else {
	outDir = "${bamf}/secondary_analysis"
}

// Creating results folder
results = "${outDir}/Results"
file(params.out_dir).mkdir()
file(results).mkdir()

workflow {

    // Bam files
    Channel
        .fromPath("${bamf}/*bam", checkIfExists:true)  
        .ifEmpty { error "Cannot find any bam files: ${params.bam_folder}" }
    	.set { ch_bam  }

    //ch_bam.view { ext, files -> "Files with the extension $ext are $files" }
    ch_bam.view()

    // Load modules
    
    include { bam2fasta } from './modules/preqc'
    include { jellyfish } from './modules/preqc'
    include { genomescope } from './modules/preqc'
    include { assembly } from './modules/assembly'
    include { evaluate_assemblies } from './modules/postqc'
    include { assemblies_completeness } from './modules/postqc'

    //Pre QC module

    //Parsing bam to fasta 
    bam2fasta( ch_bam )
    ch_bam2fastaName = bam2fasta.out[1]
    ch_bam2fastafile = bam2fasta.out[0]

    // K-mer counts and histogram 
    jellyfish (ch_bam2fastafile)
    ch_jellyfishhisto = jellyfish.out[0]

    
    // Genome profiling
    genomescope(ch_jellyfishhisto)
    ch_genomescope = genomescope.out

    //ASSEMBLY
    assembly( ch_bam)
    ch_assembly = assembly.out[0]

    // PostQC 
    // assembly evaluation
    evaluate_assemblies ( ch_assembly, ch_bam2fastafile )
    ch_assembly_evaluation = evaluate_assemblies.out[0]
    
    // assembly completeness
    assemblies_completeness(ch_assembly)


}



// Display information about the completed run
// https://www.nextflow.io/docs/latest/metadata.html
workflow.onComplete {
	log.info "Pipeline completed at: $workflow.complete"
    log.info "Nextflow Version:	$workflow.nextflow.version"
  	log.info "Command Line:		$workflow.commandLine"
	// log.info "Container:		$workflow.container"
	log.info "Duration:		$workflow.duration"
	log.info "Output Directory:	$params.out_dir"
    log.info "Execution status: ${ workflow.success ? 'OK' : 'failed' }"
}