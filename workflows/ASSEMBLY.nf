include { FASTQC; FASTQC as FASTQC_POST } from "${params.module_dir}/FASTQC.nf"
include { MULTIQC_PRE; MULTIQC_POST } from "${params.module_dir}/MULTIQC.nf"
include { TRIM } from "${params.module_dir}/TRIM.nf"
include { UNICYCLER } from "${params.module_dir}/UNICYCLER.nf"
include { QUAST } from "${params.module_dir}/QUAST.nf"
// include { BWA } from "${params.module_dir}/BWA.nf"
// include { SAMTOOLS } from "${params.module_dir}/SAMTOOLS.nf"
// include { BEDTOOLS } from "${params.module_dir}/BEDTOOLS.nf"

workflow ASSEMBLY {
        // Channel
        Channel
                .fromFilePairs(params.reads, flat: true, checkIfExists: true)
                .set { reads_ch }

        // QC
        FASTQC(reads_ch)
        MULTIQC_PRE(FASTQC.out.fastqc_reports.collect())
	TRIM(reads_ch)
	FASTQC_POST(TRIM.out.trim_reads)
	MULTIQC_POST(FASTQC_POST.out.fastqc_reports.collect())

	// Assembly
	UNICYCLER(TRIM.out.trim_reads)
	QUAST(UNICYCLER.out.quast_ch.collect())

	// Generate channel
	TRIM.out.trim_reads
		.join(UNICYCLER.out.assembly_ch, by: 0)
		.view()

	// Coverage calculation
	// BWA(mapping_ch)
	// SAMTOOLS(BWA.out.ch)
	// BEDTOOLS(SAMTOOLS.out.ch)
}
