# Automated and manual extracellular total RNA human blood plasma sequencing 
This pipeline accompanies our lab protocol for total extracellular RNA sequencing of human blood plasma. 

## Preparations
### Get the code
You can download the code and necessary files by cloning the GitHub repository: 
```ruby 
git clone [https://github.com/OncoRNALab/totalexRNAseq.git]
cd totalexRNA
```
### Snakemake
The pipeline relies on the proper installation of [snakemake](https://snakemake.readthedocs.io/en/stable/getting_started/installation.html), so make sure to install and activate snakemake before use:
```ruby
conda create -c conda-forge -c bioconda -n snakemake snakemake
conda activate snakemake
snakemake --help
```

###  Input file organization
Currently, the pipeline requires a rather strict input folder organization where each sequenced sample requires its own subfolder in which all FASTQ files are present. Paired-end sequenced libraries should match `*R1*.fast.qz`(read 1) and `*R2*.fastq.gz`(read 2). Single-end sequenced libraries do not require specific naming of the FASTQ files. The sample folders can contain multiple FASTQ files, which are combined in the `combine`rule. You can double check the `tests/input` folder as an example of what works. 

### config.yml
The pipeline expects the correct indexes to be provided in the `config/config.yml` file, so make sure to adjust those settings. In there, you should indicate what sequencing approach you used to generate the data ('se' or 'pe'). The pipeline does not autodetect the version or sequencing approach. 

In addition, you should change the input and output folders in the config file under `input_dir` and `output_dir`.


## Run the pipeline
You can run the pipeline by running the following command in your terminal. The first line makes sure that, when environments are created, your local python packages are disregarded so that they are properly and newly installed in the environments.

```ruby
snakemake --cores 4 --software-deployment-method apptainer --singularity-args "--bind /<path>/resources"
```
Set the `--singularity-args` argument to the location where all indexes and annotation files can be found. 

In theory, you could run the pipeline locally, but since it relies on STAR for read mapping, the complete index is loaded in memory. This is usually the drop in the emmer who is already full for you computer. 
