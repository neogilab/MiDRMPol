# MiDRMPol
A high-throughput multiplexed amplicon sequencing workflow to quantify drug resistance mutations (DRMs) against protease, reverse transcriptase and integrase inhibitors. MiDRMpol is computational as well as labor efficient bioinformatics pipeline to detect DRMs from HTS data.The method can be incorporated in large scale surveillance of HIV-1 DRMs.

## Background
The detection of drug resistance mutations (DRM) in minor viral populations is of potential clinical importance. However, sophisticated computational infrastructure and competence for analysis of high throughput sequence (HTS) data is lacking at most diagnostic laboratories. We propose a new pipeline, MiDRMpol, to quantify DRM from HIV-1 pol region. The pipeline accepts raw fastq reads as input and output list mutations.

## Method
The gag-vpu region of HIV plasma samples from three cohorts were amplified and sequenced by Illumina HiSeq2500 in paired-end mode. The sequence reads were pre-processed to remove adapter sequences and other contaminants followed by analysis using in-house scripts. Samples from Swedish and Ethiopian cohorts were also sequenced by Sanger sequencing. The pipeline was validated against the online tool PASeq (Polymorphism Analysis by Sequencing).

## Requirements
The pipeline requires fastq pre-processing tools such as Cutadapt (https://cutadapt.readthedocs.io/en/stable/index.html),
sickle (https://github.com/najoshi/sickle) and FastUniq (https://sourceforge.net/projects/fastuniq/). For alignment Bowtie2 & blastx are required. Python 2.7 & Perl are needed for the executions of the in-house scripts. The pipeline is tested on Linux-Ubuntu 14.04 distribution. All the tools must be available in the system path.

## Example Usage
### Pre-processing
    perl pre-processing.pl -cfg config.txt -input /path/FastQ -gzip TRUE -thread 5
##### options
    -cfg	  : path to config file

    -input	  : path to directory contains raw fastq files

    -gzip	  : input fastq is gzipped or not. Give TRUE or FALSE

    -thread	  : Number of threads to be used

config file should contain names of samples separated by new line. Eg: If paired-end file names are Sample1_R1.fastq & Sample1_R2.fastq, add "Sample1" into the config.

### Alignment
    perl Alignment.pl -cfg config.txt -thread 5
##### options
    -cfg	  : path to config file
    -thread	  : Number of threads to be used

### DRM quantification
    perl MiDRMPol.pl config.txt
##### options
    -cfg	: path to config file

### Output Folders
cutadapt_Output : Adapter trimmed fastq files will be written to the folder.

sickle_Output   : Quality filtered fastq files will be written to the folder.

FastUniq_Output : Duplicate removed fastq files will be written to the folder.

Alignment_Output: Alignment results will be writtern to the folder

DRM_Tables  : Raw, unfiltered mutation tables will be written to the folder.

MiDRMPol_Result.txt : Filtered DRMs identified in the input samples.
