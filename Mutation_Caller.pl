@Input=qx(ls DRM_Tables/*.txt);
system("rm MiDRMPol_Result.txt");
$count=@Input;
open OUT, ">>MiDRMPol_Result.txt" or die "cant";
print OUT "SampleName\tRegion\tReference_AminoAcid\tPosition\tMutated_AminoAcid\tMutated_AminoAcid_Count\tMutated_AminoAcid_Percentage\n";
close OUT;
for($z=0;$z<$count;$z++)
{
open F1, "$Input[$z]" or die "cant";
open OUT, ">>MiDRMPol_Result.txt" or die "cant";
@Name=split("/",$Input[$z]);
@name=split("\\.",$Name[1]);
$i=1;
$prt=1;
$rt=1;
$rna=1;
$int=1;

#list of DRMs to be checked in Reverse Transcriptase inhibitor. It is possible to add as many DRMs in the format "ReferenceAminoAcid:Position:MutantAminoAcid"
@RT=qw{M:41:L K:65:R D:67:N D:67:G D:67:E T:69:D K:70:R K:70:E L:74:V L:74:I V:75:M V:75:T V:75:A V:75:S F:77:L Y:115:F F:116:Y Q:151:M M:184:V M:184:I L:210:W T:215:Y T:215:F T:215:I T:215:S T:215:C T:215:D T:215:V T:215:E K:219:Q K:219:E K:219:N K:219:R L:100:I K:101:E K:101:P K:103:N K:103:S V:106:M V:106:A V:179:F Y:181:C Y:181:I Y:181:V Y:188:L Y:188:H Y:188:C G:190:A G:190:S G:190:E P:225:H M:230:L};

#list of DRMs to be checked in intgrase inhibitor
@INTG=qw{T:66:A T:66:K T:66:I E:92:Q E:138:K E:138:A E:138:T G:140:S G:140:A G:140:C Y:143:R Y:143:C Y:143:H Q:148:H Q:148:R Q:148:K N:155:H R:263:K S:147:G};

#list of DRMs to be checked in protease inhibitor
@PROT=qw{V:32:I M:46:I M:46:L I:47:V I:47:A G:48:V G:48:M I:50:V I:50:L L:76:V V:82:A V:82:T V:82:F V:82:S V:82:C V:82:M V:82:L I:84:V I:84:A I:84:C N:88:D N:88:S L:90:M};
while(<F1>)
{
	chomp $_;
	if ($_=~/^ReferencePosition/)
	{
		@head=split(" ",$_);
		next;
	}
	@arr=split(" ",$_);
	#Protease
	if(($i>=1) && ($i<100))
	{
		$ln=@PROT;
		for($j=0;$j<$ln;$j++)
		{
			@tmp=split(":",$PROT[$j]);
			$h=@head;
			for($k=0;$k<$h;$k++)
			{
				if($head[$k] eq $tmp[2])
				{
					last;
				}
			}
			$mut=($arr[$k]/$arr[4])*100;
			if($prt == $tmp[1])
			{
				if($mut > 1) # Mutation percentage cut-off
				{
					print OUT "$name[0]\tPI\t$tmp[0]\t$tmp[1]\t$tmp[2]\t$arr[$k]\t$mut\n";
				}
			}
		}
		$prt++;	
	}
	#RT
	if(($i>=100) && ($i<540))
	{	
		$ln=@RT;
		for($j=0;$j<$ln;$j++)
		{
			@tmp=split(":",$RT[$j]);
			$h=@head;
			for($k=0;$k<$h;$k++)
			{
				if($head[$k] eq $tmp[2])
				{
					last;
				}
			}
			$mut=($arr[$k]/$arr[4])*100;
			if($rt == $tmp[1])
			{
				if($mut > 1) # Mutation percentage cut-off
				{
					print OUT "$name[0]\tRTI\t$tmp[0]\t$tmp[1]\t$tmp[2]\t$arr[$k]\t$mut\n";
				}
			}
		}
		$rt++;
	}
	#RNAase
	if(($i>=540) && ($i<660))
	{
		
	}
	#Integrase
	if(($i>=660) && ($i<948))
	{
		$ln=@INTG;
		for($j=0;$j<$ln;$j++)
		{
			@tmp=split(":",$INTG[$j]);
			$h=@head;
			for($k=0;$k<$h;$k++)
			{
				if($head[$k] eq $tmp[2])
				{
					last;
				}
			}
			$mut=($arr[$k]/$arr[4])*100;
			if($int == $tmp[1])
			{
				if($mut > 1) # Mutation percentage cut-off
				{
					print OUT "$name[0]\tINI\t$tmp[0]\t$tmp[1]\t$tmp[2]\t$arr[$k]\t$mut\n";
				}
			}
		}
		$int++;
		
	}
	$i++;
}
}
