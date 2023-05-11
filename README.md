## flow_cytometry_bcbb_rtb_collab

### Aim
Generate a container, that can perform operations such as Quality Control on `fcs` files.
Once created, this container can be provided to third parties to do analysis.

### Usage

#### About the container

We're using a base image from R, specifically r-base:4.2.2
`pandoc` is required by the pipeline, and we install this on top of base.
Root is set as `/usr/local/src/myscripts`, and we copy whatever exists in this repo there.
We use `renv.lock` to define our R environment, and this env is built with the command:
`Rscript -e env::restore()`
The Dockerfile in this repo does the above.

#### To build:

`docker build --progress=plain . -t flow_cyt_pipeline`

#### To Use:
A directory needs to exist called `RTB` into which fcs files are placed.

To look at the R code you can run:
`docker run -it --rm -v $(pwd)/RTB/:/usr/local/src/myscripts/RTB/ flow_cyt_pipeline bash`

This will drop you into a functional R environment, within which you can run the script.

An example of how this might look is:

```
root@d1e73edfe4ce:/usr/local/src/myscripts# Rscript QC_script_flowai.R
There were 15 warnings (use warnings() to see them)
Quality control for the file: test
20.76% of anomalous cells detected in the flow rate check.
0% of anomalous cells detected in signal acquisition check.
47.23% of anomalous cells detected in the dynamic range check.
A flowSet with 1 experiments.

column names(17): FSC-A FSC-H ... G780-A Time
```

If we would like to see what these warnings are the QC_script_flowai.R file can be edited, and re run with:
`options(warn=1)`
added to the top of the R file.

This script generates a directory called: `RTB_flowAI`, into which it places outputs.
This might look like:

`ls  RTB_flowAI/
_QCmini.txt  test_QC.fcs  test_QC.html
`

What might be a nice starting point would be if we could define input and output directories, allowing something like
`docker run -it --rm  --name devtest   -v $(pwd)/RTB/:/usr/local/src/myscripts/RTB/ -v $(pwd)/demo_outputs/:/usr/local/src/myscripts/demo_outputs flow_cyt_pipeline Rscript QC_script_flowai.R input_dir RTB output_dir demo_outputs`

And this will run the pipeline, and drop the outputs into `demo_outputs`.

The aobve would require the script to accept arguments such as an input_dir, and an output_dir.
Another feature that might be useful would be an argument defining which type of QC analysis to be performed (eg FlowAI). https://bioconductor.org/packages/3.16/bioc/html/flowAI.html

Note, currently only FlowAI is available within the container.
