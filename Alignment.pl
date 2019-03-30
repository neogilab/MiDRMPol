use Getopt::Long;

my $config ='';
my $Threads = '';


GetOptions(
    'cfg=s' =>\$config,
    'thread=s'=>\$Threads,
    'input=s'=>\$path
    );

if(($config eq '') or ($Threads eq ''))
{
	print "\n*****Please provide all the options*****\n\n";
	print "-cfg\t: path to config file\n-thread\t: Number of threads to be used\n\n";
exit;
}
system("mkdir Alignment_Output");

open F1, "$config" or die "cant open";

while(<F1>)
{
	chomp $_;
	print "**** Bowtie2 Alignment status of $_ ****\n";
	system("bowtie2 -p $Threads --very-sensitive-local -x db/polNucl -U FastUniq_Output/$_\_R1.fastq,FastUniq_Output/$_\_R2.fastq -S Alignment_Output/$_.sam");

	open F2, "Alignment_Output/$_.sam" or die "cant";
	open F3, ">Alignment_Output/$_\_Aligned.fasta" or die "cant";
	while($in=<F2>)
	{
		chomp $in;
		next if($_=~/^@/);
		@arr=split("\t",$in);
		if($arr[2] ne "*")
		{
			$i++;
			print F3 ">$arr[0]\n$arr[9]\n";
		}	
	}
	close F2;
	close F3;
	system("blastx -query Alignment_Output/$_\_Aligned.fasta -db db/PolProt -num_threads $Threads -max_target_seqs 50 -show_gis -outfmt 5 -out Alignment_Output/$_\_blastx.xml");
}
close F1;

