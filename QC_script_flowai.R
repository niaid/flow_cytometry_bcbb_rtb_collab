# Load packages
library(flowAI)
library(flowCore)

# Place input file in a folder called RTB to run below script
# Need to be done  within the same project directory as the location of the QC script
# Posit/Rstudio dev editor can locate the relative path of this RTB folder but other environments
# may need to identify the current working environment when using list.files or other functions
# involving relative paths such as the fsApply script below
files <- list.files("RTB", full.names = T, recursive = T)

# FCS files
FCS_FILES <- files[tools::file_ext(files) == "fcs"]

# Load flow set
fs <- read.flowSet(files = FCS_FILES)

# QC using flowAI
# Recommend to run on raw data before any compensation or transformation (not recommended for mass cytometry/CyTOF)
# Key parameters to consider allowing users to modify for flow cytometry data include following:
# remove_from, alphaFR (default 0.01, decrease to make rate check less sensitive), pen_valueFS (default 500, increase to make detection of anomaly by signal less strict)
# See https://www.bioconductor.org/packages/devel/bioc/vignettes/flowAI/inst/doc/flowAI.html
fsApply(fs, FUN = function(x) try(flow_auto_qc(fcsfiles = x, folder_results = "RTB_flowAI", mini_report = "_QCmini", html_report = "_QC")))
