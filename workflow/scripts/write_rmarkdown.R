#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

output_dir <- args[1]
output_html <- args[2]
sequencing <- args[3]  # "se" or "pe"

library(rmarkdown)
rmarkdown::render('workflow/scripts/QC.Rmd', params=list(args=output_dir, sequencing=sequencing),  output_file = output_html)
