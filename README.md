# CRC
#### Part1 Parameterized Parallel Cyclic Redundancy Check (CRC) Design
Please type in the command like below:<br />
```
perl CRC.pl 8 11101
```
Then press Enter. <br />
8 is the data width, 11101 is the coefficients of the polynomial function.<br />
This perl code will generate the design part code file: CRC.v<br />
The words displayed on the screen show the detail steps of the code. You can ignore that.<br />
#### Part2 Automated Testbench Generation
Similarly, Please type in the command like below:<br />
```
perl CRC_tb.pl 8 11101
```
Then press Enter. Make sure the numbers(8 and 11101) are identical to what you have entered just now.<br />
This perl code will generate the testbench part code file: CRC_tb.v<br />
And the Golden Result is displayed on the screen.<br />
