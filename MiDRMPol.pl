#Author : Anoop Ambikan (https://github.com/anoop1988)

use Getopt::Long;

my $config ='';

GetOptions(
    'cfg=s' =>\$config,
    );

if(($config eq ''))
{
	print "\n*****Please provide all the options*****\n\n";
	print "-cfg\t: path to config file\n\n";
exit;
}

system("mkdir DRM_Tables");

open F1, "$config" or die "cant open";
while(<F1>)
{
	chomp $_;
	system("python2.7 AAcounter.py Alignment_Output/$_\_blastx.xml > DRM_Tables/$_.txt");
}
 
close F1;

#system("perl Mutation_Caller.pl");

system("perl Mutation_Caller_2.0.pl");
