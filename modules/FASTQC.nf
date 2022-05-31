process FASTQC {
        tag "$datasetID"

        input:
        tuple val(datasetID), file(R1), file(R2)

        output:
        file("*")
        path "$datasetID/*_fastqc.zip", emit: fastqc_reports

        """
        mkdir $datasetID
        fastqc $R1 $R2 -o $datasetID -t $task.cpus
        """
}
