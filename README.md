## flow_cytometry_bcbb_rtb_collab

### Aim
Allow users to convenient access to algorithms that can perform operations such as Quality Control on `fcs` files.
Below discusses creating a Docker container which contains the pipeline. Running local containers allows users to avoid uploading and downloading their work.


### Usage

#### About the Dockerfile

We're using a base image from R, specifically `r-base:4.2.2`
from [here](https://hub.docker.com/layers/library/r-base/4.2.2/images/sha256-94ba89c4503af7c69dca11e855c24f30af8e21c43399d664a68ef8ae05a9f5a0?context=explore).

`pandoc` is required by the pipeline, and we install this on top of base.

Root is set as `/usr/local/src/myscripts`, and we copy whatever exists in this repo there.

We use `renv.lock` to define our R environment, and this env is built with the command:

`Rscript -e env::restore()`



#### To build:

`docker build --progress=plain . -t flow_cyt_pipeline`

#### To Use:
A directory needs to exist called `RTB` into which fcs files are placed.

To look at the R code you can run:
```
docker run -it --rm \
-v $(pwd)/RTB/:/usr/local/src/myscripts/RTB/ \
flow_cyt_pipeline bash
```

This will drop you into an R environment, within which you can run the script.

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

This script generates a directory called: `RTB_flowAI`, into which it places outputs. Note that this is inside the container, and will vanish upon the container ending.

This output dir might look like:

```
ls  RTB_flowAI/
_QCmini.txt  test_QC.fcs  test_QC.html
```

One starting point would be if we could define `input` and `output` directories, allowing something like
```
docker run -it --rm  --name devtest \
-v $(pwd)/RTB/:/usr/local/src/myscripts/inputs \
-v $(pwd)/demo_outputs/:/usr/local/src/myscripts/outputs \
flow_cyt_pipeline \
Rscript QC_script_flowai.R input inputs output outputs
```

And this will run the pipeline, and drop the outputs into `demo_outputs`.

The aobve would require the script to accept arguments such as an `input`, and `output`.
Another feature that might be useful would be an argument defining which type of QC analysis to be performed eg [FlowAI](https://bioconductor.org/packages/3.16/bioc/html/flowAI.html).

Note, currently only FlowAI is available within the container.
