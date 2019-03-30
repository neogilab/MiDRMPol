use Getopt::Long;

my $path='';
my $config ='';
my $Threads = '';
my $Gzipped='';

GetOptions(
    'cfg=s' =>\$config,
    'thread=s'=>\$Threads,
    'gzip=s'=>\$Gzipped,
    'input=s'=>\$path
    );

if(($config eq '') or ($Threads eq '')  or ($Gzipped eq '') or ($path eq ''))
{
	print "\n*****Please provide all the options*****\n\n";
	print "-cfg\t: path to config file\n-input\t: path to directory contains raw fastq files\n-gzip\t: input fastq is gzipped or not. Give TRUE or FALSE\n-thread\t: Number of threads to be used\n\n";
	exit;
}

open F1, "$config" or die "cant";

system("mkdir cutadapt_Output");
system("mkdir sickle_Output");
system("mkdir FastUniq_Output");

while(<F1>)
{
	chomp $_;
	#if the adapter sequences are different, should be replaced in the command
	if($Gzipped eq "TRUE")
	{
		system("cutadapt -a GATCGGAAGAGCACACGTCTGAACTC -A GAGTTCAGACGTGTGCTCTTCCGATC -a AGATCGGAAGAGCGTCGTGTAGGGAA -A TTCCCTACACGACGCTCTTCCGATCT -a TTCCCTACACGACGCTCTTCCGATCT -A AGATCGGAAGAGCGTCGTGTAGGGAA -a GAGTTCAGACGTGTGCTCTTCCGATC -A GATCGGAAGAGCACACGTCTGAACTC -b GATCGGAAGAGCACACGTCTGAACTC -B GAGTTCAGACGTGTGCTCTTCCGATC -b AGATCGGAAGAGCGTCGTGTAGGGAA -B TTCCCTACACGACGCTCTTCCGATCT -b TTCCCTACACGACGCTCTTCCGATCT -B AGATCGGAAGAGCGTCGTGTAGGGAA -b GAGTTCAGACGTGTGCTCTTCCGATC -B GATCGGAAGAGCACACGTCTGAACTC -j $Threads -m 30 -o cutadapt_Output/$_\_R1.fastq -p cutadapt_Output/$_\_R2.fastq $path/$_\_R1.fastq.gz $path/$_\_R2.fastq.gz");
	}
	else
	{
		system("cutadapt -a GATCGGAAGAGCACACGTCTGAACTC -A GAGTTCAGACGTGTGCTCTTCCGATC -a AGATCGGAAGAGCGTCGTGTAGGGAA -A TTCCCTACACGACGCTCTTCCGATCT -a TTCCCTACACGACGCTCTTCCGATCT -A AGATCGGAAGAGCGTCGTGTAGGGAA -a GAGTTCAGACGTGTGCTCTTCCGATC -A GATCGGAAGAGCACACGTCTGAACTC -b GATCGGAAGAGCACACGTCTGAACTC -B GAGTTCAGACGTGTGCTCTTCCGATC -b AGATCGGAAGAGCGTCGTGTAGGGAA -B TTCCCTACACGACGCTCTTCCGATCT -b TTCCCTACACGACGCTCTTCCGATCT -B AGATCGGAAGAGCGTCGTGTAGGGAA -b GAGTTCAGACGTGTGCTCTTCCGATC -B GATCGGAAGAGCACACGTCTGAACTC -j $Threads -m 30 -o cutadapt_Output/$_\_R1.fastq -p cutadapt_Output/$_\_R2.fastq $path/$_\_R1.fastq $path/$_\_R2.fastq");
	}
	system("sickle pe -f cutadapt_Output/$_\_R1.fastq -r cutadapt_Output/$_\_R2.fastq -o sickle_Output/$_\_R1.fastq -p sickle_Output/$_\_R2.fastq -t sanger -s sickle_Output/$_\_SE.fastq -q 30 -l 30");
	open OUT, ">FastUniq_Output/$_.txt" or die "cant";
	print OUT "sickle_Output/$_\_R1.fastq\nsickle_Output/$_\_R2.fastq";
	system("fastuniq -i FastUniq_Output/$_.txt -o FastUniq_Output/$_\_R1.fastq -p FastUniq_Output/$_\_R2.fastq");
}
