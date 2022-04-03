process evaluate_assemblies {
    tag "$name"
    label 'evaluate_assemblies'

	publishDir "${params.resultsQuast}/${name}", mode: "copy", saveAs: { filename -> filename.endsWith('primary') ? "primary_contig" : PASS } 
    publishDir "${params.resultsQuast}/${name}", mode: "copy", saveAs: { filename -> filename.endsWith('associate') ? "associate_contig" : PASS } 
        // module 'quast'

	input:
    tuple file(primary), file(secondary), val(name)
    tuple file(css_fasta), val(input)
	

	output:
	file("*")

	shell:
	"""
        #quast.py -o ${name}_primary -t 32 -l primary_contig --pacbio ${css_fasta} ${primary}
        quast.py -o ${name}_primary -t 32 -l primary_contig  ${primary}
        quast.py -o ${name}_associate -t 32 -l associate_contig  ${secondary}
	"""	
}

process assemblies_completeness {
    tag "$name"
    label 'assemblies_completeness'
    // module 'python/3.6.6:blast/2.10.0:hmmer/3.2.1:busco/3.0.2:boost/1.67.0:augustus/3.3.2'

   
    publishDir "${params.resultsBusco}/${name}",  mode: 'copy',  saveAs: { filename -> filename.endsWith('primary_busco') ? "primary_contig" : PASS } 
    publishDir "${params.resultsBusco}/${name}",  mode: 'copy',  saveAs: { filename -> filename.endsWith('associate_busco') ? "associate_contig" : PASS } 

    input:
    tuple file(primary), file(secondary), val(name)
    
    output:
    file("*")

    shell:
    """
    busco -f -i $primary -o primary_busco -l $params.busco_db -c 32 -m genome --offline
    busco -f -i $secondary -o associate_busco -l $params.busco_db -c 32 -m genome --offline
    """	
}