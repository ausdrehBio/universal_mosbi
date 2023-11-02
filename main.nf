params.output = "./output/"
params.input = "./example/"
params.meta_file = "columnDescription.txt"
params.count_file = "data_withoutGenes.csv"
params.algrorithm = "base" //"extra" or "all"
params.min_size = 3
params.timepoint = true 
params.protein_mapping = true 

meta_file = Channel.fromPath("${params.meta_file}")

count_file = Channel.fromPath("${params.count_file}")

script_file = file("$baseDir/universal.r")
file('paramsmeta_file.txt').withWriter { writer ->
    writer.println "params.meta_file: ${params.meta_file}"
    writer.println "params.input: ${params.input}"
}


process mosbi {
    container "bioandre/mosbi_container" // use docker conatainer
    memory "8 GB"
    publishDir params.output, mode: "copy"

    input:
    path script_file
    path count_file
    path meta_file

    

    // output:
    // path "community*"
    // path "GraphML_*"
    // path "Rplots.pdf"

   

    """
    Rscript $script_file ./ $count_file $meta_file ${params.algrorithm} ${params.min_size} ${params.protein_mapping} ${params.timepoint}
    """
}


workflow {
  mosbi(script_file, count_file, meta_file)
}
