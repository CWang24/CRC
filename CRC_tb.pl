#!/usr/local/bin/perl
$file = 'CRC_tb.v';
open(OUT,">$file");
#open OUT,'>'.$file;
$input = @ARGV;
$data_width=$ARGV[0];
$polynomial_function=$ARGV[1];
#if($data_width<7)
#print "Since the TA want us to test 100 cases, the data width you enter should be greater than 6!\n";
$data_width_1=$data_width-1;
	$CRClengthorigin=length($polynomial_function);
	$CRClength=length($polynomial_function)-1;
#print the head of the .v file
print OUT "`timescale 1ns/10ps
module tb;
reg [$data_width_1:0] data_in;
crc crc_tb(data_in,crc_out);
initial
	begin\n";
#this is the maximum number.
$data_in=();
while(length($data_in)<$data_width)
{$data_in=$data_in."1";}
print OUT "	data_in=$data_width";print OUT "'b$data_in;\n	#2;\n";

$data_inn=0;
while(length($data_inn)<$data_width)
{$data_inn=$data_inn."0";}
print OUT "	data_in=$data_width";print OUT "'b$data_inn;\n	#2;\n";


#now we turn that into a decimal number.
$Max=oct( "0b$data_in");
#print "max in decimal:$Max\n";
my @randNum_origin = createRandNum($Max,99);  #(range,quantity) may contain 000...00 but won't contain 111...11
$jjjj=0;
my @randNum=();
$flag=0;
foreach $rawdata (@randNum_origin)
{
	if ($rawdata==0)
	{$flag=1;}
}
if($flag==1)#means 1 of the 99 is 0, and we should skip that one.
{
	foreach $rawdata (@randNum_origin)
	{
		if($rawdata!=0)
		{push @randNum,$rawdata;}
	}
}
if($flag==0)#mean all 99 are non-zero, and we should skip one of them, for example the first one.
{
	foreach $rawdata (@randNum_origin)
	{
		if($flag==1)
		{push @randNum,$rawdata;}
		$flag=1;
	}	
}
#print "@randNum \n";###############
print"When polynomial function is $polynomial_function, and the\n";

$data_in=();
while(length($data_in)<$data_width)
{$data_in=$data_in."0";}
print "data input is $data_in, ";
&getCRC;
print "CRC is $CRC.\n";
$data_in=();
while(length($data_in)<$data_width)
{$data_in=$data_in."1";}
print "data input is $data_in, ";
&getCRC;
print "CRC is $CRC.\n";
foreach $data_in4print (@randNum)
{
	$data_in4print=sprintf( "%b", $data_in4print);
	while(length($data_in4print)<$data_width)
	{$data_in4print="0".$data_in4print;}
	print OUT "	data_in=$data_width";print OUT "'b$data_in4print;\n	#2;\n";
	print "data input is $data_in4print, ";
	$data_in=$data_in4print;
	$data_in_sp=$data_in;

	$ii=0;
	$iii=0;
	&getCRC;
	print "CRC is $CRC.\n";
	$CRCorigin=$CRC;
}
print OUT '	$';
print OUT "stop; \n	end\nendmodule";

#$data_in=11011011;




sub createRandNum
{
    my ($MaxNum,$MaxCount) = @_;
    my $i = 0;
    my %rand = ();
    while (1)
    {
        my $no = int(rand($MaxNum));
        if (!$rand{$no})
        {
            $rand{$no} = 1;
            $i++;
        }
        last if ($i >= $MaxCount);
    }
    my @randnum = keys % rand;
    return @randnum;
}
sub getCRC
{
	while(length($polynomial_function)<$data_width)
	{$polynomial_function=$polynomial_function."0";}
	$data_in_dec=oct( "0b$data_in");
	$polynomial_function_dec=oct( "0b$polynomial_function");
	$zeros=0;
	while($zeros< $data_width)
	{
		$XORresult_dec=$data_in_dec^$polynomial_function_dec;
		$XORresult_bin=sprintf( "%b", $XORresult_dec);	
		while(length($XORresult_bin)<$data_width)
		{
			$XORresult_bin=$XORresult_bin."0";
			$zeros++;
		}		
		$data_in_bin=$XORresult_bin;
		$data_in_dec=oct( "0b$data_in_bin");
	}
	my $count=$zeros-$data_width;
	while($count)
	{
		$XORresult_bin="0".$XORresult_bin;
		$count--;
	}
	$CRC=substr("$XORresult_bin",0,$CRClength);
}

