FROM rocker/tidyverse:3.6.0

####################
### APT packages ###
####################

# (transdecoder comes with cd-hit-est 4.6)
# qpdf is for building R packages
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		bedtools=2.26.0+dfsg-3 \
		fasttree \
		htop \
		mafft=7.307-1 \
		maven=3.3.9-4 \
		mcl=1:14-137-1+b1 \
		nano \
		ncbi-blast+=2.6.0-1 \
		phyutility=2.7.3-1 \
		python-biopython \
		qpdf \
		t-coffee=11.00.8cbe486-5 \
		transdecoder=3.0.1+dfsg-1 \
		python-pip \
	# Python libraries (for PASTA)
	&& pip install DendroPy \
	&& apt-get clean

##################
### R packages ###
##################

# Run install_packages.R in rocker/tidyverse:3.6.0 first to create
# packrat/packrat.lock - see comments in install_packages.R.

COPY ./packrat/packrat.lock packrat/

RUN Rscript -e 'install.packages("packrat", repos = "https://cran.rstudio.com/")'

RUN Rscript -e 'packrat::restore()'

# .Rprofile doesn't get parsed by Rstudio, so modify Rprofile.site instead
# This is needed so R uses packrat libraries by default
RUN echo '.libPaths("/packrat/lib/x86_64-pc-linux-gnu/3.6.0")' >> /usr/local/lib/R/etc/Rprofile.site

###############################
### Yang and Smith workflow ###
###############################

WORKDIR /home
RUN git clone https://bitbucket.org/yangya/phylogenomic_dataset_construction.git

######################
### Other software ###
######################

ENV APPS_HOME=/apps
RUN mkdir $APPS_HOME

### PASTA ###
WORKDIR $APPS_HOME
ENV APP_NAME=pasta
ENV DEST=$APPS_HOME/$APP_NAME
RUN git clone https://github.com/smirarab/$APP_NAME.git \
	&& git clone https://github.com/smirarab/sate-tools-linux.git
WORKDIR $DEST
RUN python setup.py develop

### RAxML ###
WORKDIR $APPS_HOME
ENV APP_NAME=standard-RAxML-8.2.12
ENV DEST=$APPS_HOME/$APP_NAME
RUN wget https://github.com/stamatak/standard-RAxML/archive/v8.2.12.zip \
	&& unzip v8.2.12.zip
WORKDIR $DEST
RUN make -f Makefile.AVX.PTHREADS.gcc \
  && cp raxmlHPC-PTHREADS-AVX /usr/bin/raxml \
	&& chmod u+x /usr/bin/raxml

WORKDIR /home/rstudio
