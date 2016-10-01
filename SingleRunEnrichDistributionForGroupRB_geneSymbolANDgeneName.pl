#!/usr/bin/perl
##############################
# compute tag distribution
##############################
use strict;
use Getopt::Long;
use Cwd;

# to run this code you have to place all the annotation files you want to process in one directory.
#they all should have a unique start - for example: "annoPercent".
#as -t you shouhld typr the beginning of the file's name: "annoPercent".
#as -g you should give the suffix of the group file name - for example: ".mb_grp"

#@test_in,

#usage: perl SingleRunEnrichDistributionForGroupRB_geneSymbol.bash -u 3000 -d 3000 -t anno_smalltssU5000tssD5000.txt -g AllHumanGenes_geneName_geneSymabol.grp 

my ($helpFlag, $file_tag, $file_group,$file_out_tss);
my @groupfiles=();
my @tagfiles=();
my $filename;
my %hs_group = ();
my $pwd;
$file_group=0;
$file_tag=0;
my $key99, my $value99;

GetOptions(
   "h|?|help" => \$helpFlag,
   "u:i" => \my $upstream,
   "d:i" => \my $downstream,
   "t:s" => \$file_tag,
   "g:s" => \$file_group,
);


checkOptions();



my @gene=();
my $MostUpstreamPosition=0;
my ($i,$j,$once,$pos, $annotatedGene,$annotatedId,$Group_GeneName,$Group_GeneID,$same,$tmp_name_group,$tmp_name_annotation);

print "Input Parameters:\n";
print "Upstream TSS distance = $upstream;\nDownstream TSS distance = $downstream;\nTag file = $file_tag;\nGroup file = $file_group;\n";


# output filename based on name input files
my $file_group2 = substr ($file_group,0,((length$file_group)-4));
$file_group2 = "Group$file_group2\_";

##print "$file_group2\n";

my $tmpfile_out_tss = substr ($file_tag,0,((length$file_tag)-4));

$file_out_tss = $file_group2.$tmpfile_out_tss . "_U" . $upstream . "D" . $downstream;

    open(FL, $file_tag) || die "Cannot open $file_tag: $!.";
    my @test_in = ();
    @test_in = <FL>;
    close FL;
    
    open (FL2, $file_group) || die "Cannot open $file_group:$!.";
    my @test_in2 = ();
    @test_in2 = <FL2>;
    close FL2;

open(FOUT, ">EnrichDis_$file_out_tss.txt") || die "Cannot create $file_out_tss: $!.";
open(FOUT2, ">Genes_EnrichDis_$file_out_tss.txt") || die "Cannot create $file_out_tss: $!.";
print "Output tag frequency file = EnrichDis_$file_out_tss.txt\n";
$i=0;


foreach (@test_in2){ #read from groups array
    my @GroupValues=();
    @GroupValues = split(/\t/);
    $Group_GeneName = $GroupValues[0];
	$Group_GeneID = $GroupValues[1];
		
        chomp ($Group_GeneName,$Group_GeneID);
		chop $Group_GeneID; #this chop is important! without it there will be no match!!
		$tmp_name_group=$Group_GeneName . "~" . $Group_GeneID;
		$hs_group{$tmp_name_group}=$tmp_name_group;
		}
		
my $f=0;
my $firstone=0;
    
    #print "@test_in\nbbbbbbbbbbbbbbbbb";
	#sorting the annofile so the first one is the very upstream position, then sort by the gene name, then sort by the gene id!
    @test_in = sort { (split /\t/, $a)[0] <=> (split /\t/, $b)[0]||(split /\t/, $a)[1] cmp  (split /\t/, $b)[1] ||(split /\t/, $a)[2] cmp  (split /\t/, $b)[2]} @test_in;
    #print "@test_in\n";
    chomp;
    my %hs_vals = ();
    my %hs_repeats = ();    
    my @tmp1=split(/\t/,$test_in[0]);
    $MostUpstreamPosition=$tmp1[0];
    print "\nThe most upstream position in the $file_tag is: $MostUpstreamPosition\n";
    #initialize your associative array with zeros
    for ($j=(-1)*$upstream;$j<=$downstream;$j++){
        $hs_vals{$j}=0;
        $hs_repeats{$j}=0;
    }
   
    foreach(@test_in){# read from source file
    my @values=();
    @values = split(/\t/);
    if(((-1)*$upstream <= $values[0]) and ($values[0] <= $downstream)){
    $annotatedGene=$values[1];
	$annotatedId=$values[2];
    chomp ($annotatedGene,$annotatedId);
	
	$tmp_name_annotation=$annotatedGene."~".$annotatedId;
    chomp ($tmp_name_annotation);
  
        #if ($^O eq "darwin" or $^O eq "linux"){chop ($Group_GeneID);}
       # if ($annotatedGene eq $Group_GeneName){#check if the gene's name of the annotated tag is included at the gene group file!  
        
		#if ($Group_GeneID =~ m/NM_015419/){
		#print "$tmp_name_annotation\t$tmp_name_group\n";}
		
		#if ($tmp_name_annotation eq $tmp_name_group){   
		#if ($tmp_name_group =~ m/$tmp_name_annotation/){ 
		if (exists $hs_group{$tmp_name_annotation}){
			$hs_vals{$values[0]}=$values[3]+$hs_vals{$values[0]};
      		##print "$tmp_name_annotation\t$tmp_name_group\n";
			##print "$values[0]\t $hs_vals{$values[0]} \n";
            if($hs_vals{$values[0]} != 0) {
               $hs_repeats{$values[0]}=$hs_repeats{$values[0]}+1;}    
                push (@gene, "$values[1]\t$values[2]");          
        }#($zz eq $zzz){
    #}#foreach(@test_in2)
 }#if(($values[0] >= (-1)*$upstream) and ($values[0] <= $downstream))
}#foreach


my $counter=0;
my $checker=0;
my @uniquelist=();

  foreach my $element(sort(@gene)){
  if ($checker eq $element){
  next;
  }
  else{
  $checker=$element;
  push (@uniquelist, $checker);
 }
}
foreach(@uniquelist){
my @values3=();
@values3= split(/\t/);
print FOUT2 "$values3[0]\t$values3[1]\n";
$counter++;
}
print FOUT2 "\n\nNumber of unique genes annotated to the defined window and gene group is: $counter\n\n";

print FOUT2 "\nTag file = $file_tag;\nGroup file = $file_group;\n";


      foreach my $key (sort {$a<=>$b} keys %hs_vals)
        {
            
            print FOUT "$key\t$hs_vals{$key}\t$hs_repeats{$key}\n";
        }
   

close FOUT;
close FOUT2;


  print "end of enrichment run $file_out_tss\n\n";
  sub checkOptions
{
   $downstream =shift(@ARGV) if !defined $downstream && @ARGV > 0;
   $upstream =shift(@ARGV) if !defined $upstream && @ARGV > 0;
   $file_tag = shift(@ARGV) if !defined $file_tag && @ARGV > 0;
   if($helpFlag || (!defined $downstream ||!defined $upstream ||!defined $file_tag ||!defined $file_group)){
      die "\nUsage: $0 \n-u Maximal upstream distance\n-d Maximal downstream distance\n-t Input annotated tag file\n-g Group file\n\n";
   }
}
