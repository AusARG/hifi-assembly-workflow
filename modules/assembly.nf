process assembly {
tag "Denovo assembly on sample: $bam_tag"
label 'assembly'

publishDir params.resultsassembly, mode: 'copy', saveAs: { filename -> filename.endsWith('p_ctg.fasta') ? "${bam_tag}_primary.fasta" : "${bam_tag}_associate.fasta" }
// module 'ipa'


input:
file(bamFile)

output:
tuple file("RUN/19-final/final.p_ctg.fasta"), file("RUN/19-final/final.a_ctg.fasta"), val("$bam_tag")


shell:
bam_tag = bamFile.baseName

script:
"""
ipa local --nthreads 40 --njobs 4 -i ${bamFile}
"""
}