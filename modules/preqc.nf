
process bam2fasta {
tag "Converting bam to fasta for sample: $bam_tag"
label 'bam2fasta'

publishDir params.resultsDirbam2fasta, mode: 'copy'


input:
file(bamFile)

output:
tuple file("*.fa"), val("$bam_tag")


shell:
bam_tag = bamFile.baseName

script:
"""
samtools fasta ${bamFile} > ${bam_tag}.fa

"""
}


process jellyfish {
tag "Generating k-mer counts and histogram  on $name"
label 'jellyfish'

publishDir params.resultsjellyfish, mode: 'copy'
// module 'jellyfish'

input:
tuple  file(fasta), val(name)

output:
tuple val(name), file("${name}.histo"), file("${name}.jf")

script:
"""
jellyfish count -C -m 21 -s 1G -t 20 ${fasta} -o ${name}.jf 
jellyfish histo ${name}.jf > ${name}.histo
"""

}


process genomescope {
tag "Profiling genome characteristics on $name"
label 'genomescope'

publishDir params.resultsgenomescope, mode: 'copy'
// module 'genomescope'

input:
tuple val(name), file(histo), file(jf)

output:
file("${name}/summary.txt") 
file("${name}/linear_plot.png")


script:
"""
genomescope.R -i ${histo} -o ${name}
"""
}