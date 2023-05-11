FROM r-base:4.2.2
COPY . /usr/local/src/myscripts
WORKDIR /usr/local/src/myscripts
RUN apt update -y && apt install -y pandoc
RUN ["Rscript", "-e", "renv::restore()"]

