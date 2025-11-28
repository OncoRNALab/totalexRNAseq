# Automated and manual extracellular total RNA human blood plasma sequencing

This pipeline accompanies our lab protocol for total extracellular RNA sequencing of human blood plasma. It provides a complete Snakemake workflow for processing both single-end and paired-end extracellular RNA sequencing data in a fully reproducible containerized environment.

## Preparations

### Get the code
You can download the code and necessary files by cloning the GitHub repository:
```bash
git clone https://github.com/OncoRNALab/totalexRNAseq.git
cd totalexRNAseq
```

### Input file organization
The pipeline requires a strict input directory structure. The main input directory must contain one subfolder per sample, and each folder must contain the FASTQ files for that sample.
Paired-end sequenced libraries should match `*R1*.fast.qz`(read 1) and `*R2*.fastq.gz`(read 2). Single-end sequenced libraries do not require specific naming of the FASTQ files. The sample folders can contain multiple FASTQ files, which are combined in the `combine`rule. Example structure from the `tests/input` folder:

```css
input/
  sample1/
    sample1_R1.fastq.gz
    sample1_R2.fastq.gz (for paired-end)
  sample2/
    sample2_R1.fastq.gz
    sample2_R2.fastq.gz
```

Notes:
- Paired-end samples must contain files matching `*R1*.fastq.gz` (read 1) and `*R2*.fastq.gz`(read 2)
- Single-end samples do not require specific naming
- Multiple FASTQ files per sample are supported; they are automatically merged with the `combine` rule.

### Setting up the config file
The configuration file is located at:
```ruby
config/config.yml
```

You must specify:
- sequencing method: "se" for single-end or "pe" for paired-end (the pipeline does **not** autodetect sequencing strategy)
- input and output directories
- paths to reference FASTA, GTF, and BED files
- path to STAR index
- memory for STAR (recommended: 60 GB, as currently listed in the config.yml)

## Running the pipeline
The workflow is executed using Snakemake with Apptainer/Singularity:
```bash
snakemake --cores 4 \
  --software-deployment-method apptainer \
  --singularity-args "--bind /<path>/resources" \
  --resources mem_mb=60000
```

- `--singularity-args` must list all resource folders containing the STAR index, FASTA, GTF, and BED files (comma-separated if multiple)
- Running locally without the container is not recommended because STAR loads the full genome index into memory.  
- `--resources mem_mb=60000` tells Snakemake how much memory is available for all jobs, you can adjust this according to your hardware. The STAR mapping requests the amount of memory specified in `config/config.yml` (default 60 GB). This ensures STAR only runs when enough memory is free, avoiding out-of-memory errors.

## Output
The workflow produces:
- Trimmed FASTQ files
- FASTQC reports
- STAR alignment BAM files
- Deduplicated BAM files
- HTSeq count tables
- A final HTML report across samples: QC.html (in the main output folder)

See the `tests/example_output` folder for an example of the pipeline output corresponding to the `se` and `pe` files in `tests/input`

## Protocol paper data
cfRNA plasma sample count files used in the protocol paper are in `paper_countdata`
