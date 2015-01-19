#!/usr/local/bin/perl
 $input = @ARGV;
 $data_width=$ARGV[0];
 $polynomial_function=$ARGV[1];
$polynomial_function_sp=$polynomial_function;
$CRCmodule='CRC.v';
$data_in=();
while(length($data_in)<$data_width)
{$data_in=$data_in."1";}
$CRC=0;
#$data_in=11001000;############
$data_in_sp=$data_in;
$poly_function_length=length($polynomial_function);
$CRClength=length($polynomial_function)-1;

&getCRC;
$CRCorigin=$CRC;
@data_in2=();
@finalResult=();
for($ii=0;$ii<$data_width;$ii++)
{
	@data_in2=();
	$causee=$data_width-1-$ii;
	push @finalResult,"cause";
	push @finalResult,$causee;
	push @finalResult,"effect";
	
	print"now we modify bitNo.$causee in the original data\n";
	for ($iii=0;$iii<$data_width;$iii++)
	{
		$AAA=substr($data_in_sp,$iii,1);
		if($iii==$ii)
		{$AAA=$AAA^1;}
		push @data_in2,$AAA;
		#print"@data_in2\n";
	}
	$data_in2=join('',@data_in2);
	print"Data_in_origin        :$data_in_sp\nData_in_modify_bitNo.$causee:$data_in2\n";

	$data_in=$data_in2;
	&getCRC;
	$CRCmodify=$CRC;
	print"Compare $CRCorigin with $CRCmodify\n";
	&bitwiseComp;
}
print "\nSummary of what we found by now:\n@finalResult\n";
print"\nNow start printing the verilog...\n";
open(OUT,">$CRCmodule");
#print the head of .v file
print OUT "//-----------------------------------------------------------------------------\n";
$datawidth4print=$data_width-1;
$CRClengthprint=$CRClength-1;
print OUT "// CRC module for data[$datawidth4print:0] ,   crc[$CRClengthprint:0]=$polynomial_function_sp\n";
print OUT "//-----------------------------------------------------------------------------\n";
print OUT "module crc(
	input [$datawidth4print:0] data_in,
	output [$CRClengthprint:0] crc_out);
	reg [$CRClengthprint:0] crc_out;
	always @(*) begin\n";
$crc_out=0;
for ($crc_out=0;$crc_out<$CRClength;$crc_out++)
{
	$first_in_row=1;
	$next='voidd';
	print OUT "		crc_out[$crc_out]=";
	foreach $element (@finalResult)
	{
		
		if ($element eq 'cause')
		{	$next='cause';	}
		if(($element ne 'cause')&($element ne 'effect')&($next eq 'cause'))
		{
			$data_in_bit=$element;
			$next='voidd';
		}
		if($element eq 'effect')
		{	$next='effect';	}
		if(($element ne 'cause')&($element ne 'effect')&($next eq 'effect'))
		{
			if($element eq $crc_out)
			{
				if($first_in_row==0)
				{print OUT "^";}
				print OUT "data_in[$data_in_bit] ";
				$first_in_row=0;
				#if($data_in_bit!=0)
				#{print"eeeennnndddd\n";	$next='voidd';}
				#else
				#{print" ^ ";}
			}
		}
	}
	print OUT ";  \n";
}

print OUT "		end // always\nendmodule // crc\n";

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
	print"get the crc output:";
	my $count=$zeros-$data_width;
	while($count)
	{
		$XORresult_bin="0".$XORresult_bin;
		$count--;
	}
	$CRC=substr("$XORresult_bin",0,$CRClength);
	print"CRC is $CRC\n";
}
sub bitwiseComp
{
	$iiii=0;
	while($iiii<$CRClength)
	{
		$AAAA=substr($CRCorigin,$iiii,1);
		$BBBB=substr($CRCmodify,$iiii,1);
		
		if($AAAA!=$BBBB)
		{
			$effectt=$CRClength-$iiii-1;
			print"If we modify bit No.$causee in data, bit No.$effectt in CRC will be affected.\n";
			push @finalResult,$effectt;
		}
	$iiii++;
	}
}
