process QUAST {
        publishDir "${params.out_dir}/02_ASSEMBLY/05_quast_report", pattern: "transposed_report.tsv", mode: "copy", saveAs: {"Quast_report.tsv"}

        input:
        file("*")

        output:
        file("*")
        path "transposed_report.tsv", emit: R_quast

        script:
        """
        quast --threads $task.cpus -o . *.fasta
        """
}
