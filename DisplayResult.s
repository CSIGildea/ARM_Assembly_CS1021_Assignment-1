	AREA	StatEval, CODE, READONLY
	IMPORT	main
	IMPORT	getkey
	IMPORT	sendchar
	IMPORT  fputs
	EXPORT	start
	PRESERVE8
		
		; Code produced by Conor Gildea in first year in 2016/2017.
start
	LDR R6,=10	; //This register will remain constant - Stage 1 - Multiply running total by 10
				;									  	 Stage 3 - Power Function - Printing
	LDR R4,=0	;
	LDR R7,=0	;
	LDR R8,=0	; //Ensuring registers are set to zero.
	LDR R9,=0	;
	LDR R10,=0	;
	LDR R12,=0	;
	LDR	R0, =hi	; System.out.print("Please enter your list of values. 
				;					Hit 'enter' after each value is entered \nand press '.' 
				;					when you are finished entering your list of values.\n")
				; Code produced by Conor Gildea in first year in 2016/2017.
	BL	fputs
extraloop
loop
read
	BL	getkey				; Read key from console
	CMP	R0,#0x0D  			; if (key != "Enter")
	BEQ	endRead				; {
	CMP	R0,#0x2E  			; 	if (key != ".")
	BEQ	endprogram			; 	{
	BL	sendchar			; 		echo key back to console
	CMP R0,#0x2D			; 		if (key != "-")
	BEQ negativenumberskip 	;		{
	CMP R0,#0x30			;			if(key>"0" )||(key<"9") *ASCII symbols* // Preventing non-numbers being entered
	BLO endprograminvalid1	;			{
	CMP R0,#0x39			;
	BHI endprograminvalid2	;
	MUL R4,R6,R4  			;  			PreviousRunningTotal*10
	SUB R5,R0,#0x30 		; 			Converting the new digit from ASCII symbol to actual hexademical number (0x39 = "9" --> 0x09)
	ADD R4,R4,R5    		;			Adding the new digit to the running total
							;			}
negativenumberskip			;		}
	CMP R0,#0x2D			;		else if (key = "-")
	BNE negativenumber		; 		{
	MOV R12,#1				;			boolean negativeNumber = true
negativenumber				;		}
	B	read				; 	}
							;}
endRead
	MOV R0,#0x20				; System.out.print(" "); 	//Placing a space between each input after enter is pressed
	BL sendchar					; Code produced by Conor Gildea in first year in 2016/2017.
	CMP R12,#1					;if (negativeNumber=true) 	//Converts negative numbers to 2 Compliment Form
	BNE negativenumberchange	;{
	MVN r4, r4 					; 	value = NOT value (invert bits)
	ADD r4, r4, #1 				; 	value = value + 1 (add 1)	
negativenumberchange			;}
	MOV R12,#0					; negativeNumber = false;
	ADD R7,R7,#1    			; count++; 					//Calculating the count in R7
	ADD R8,R8,R4    			; sum = sum + value; 		//Calculating the sum in R8		
	
	
	CMP R7,#1				; if (count=1)
	BNE firstTimeComparing 	; { 
	MOV R9,R4				; 	Max = Value Entered
	MOV R10,R4				; 	Min = Value Entered
firstTimeComparing			; }

							;//Max Number Calculation - R9
	CMP R9,R4				; if (Max<Value Entered)
	BGE maxNumber			; {
	MOV R9,R4				;  	Max = Value Entered
maxNumber					; }

							;//Min Number Calculation - R10
	CMP R10,R4      		; if (Min>Value Entered)
	BLE minNumber			; {
	MOV R10,R4				;	Min = Value Entered
minNumber					; }
	MOV R4,#0
	MOV R3,#0
	MOV R2,#0				; Resetting registers  to zero
	MOV R1,#0				; To prepare for looping back around to reading values
	MOV R12,#0				; again in stage 1
	BL getkey
	CMP	R0,#0x2E  			; if (key = .)
	BNE	endprogram			; {
; Code produced by Conor Gildea in first year in 2016/2017.
	MOV R5,R8				; newDigitRegistry = sum //As the sum moved to R5, R5 will now be refered to as the variable sum
	LDR R0,=mean			; System.out.print("\nMean:);
	BL fputs				;
	LDR R11,=2147483647		; wrapAroundPoint = 2147483647 //This is half of the max value that can be stored.
							; 							   //It is the wrapAroundPoint of the 2 Compliments system
	CMP R5,R11
	BLO negative			; if(sum>warpAroundPoint)      //If sum is negative it converts it back to unsigned numbers 
							;{									to display properly
	MVN R5, R5 				; value = NOT value (invert bits)
	ADD R5, R5, #1 			; value = value + 1 (add 1)
	MOV R0,#0x2D			; System.out.print("-")
	BL sendchar				;}

negative			;//Multiply by 100 here to allow two decimal places to be calculated in the final answer
	MUL R5,R6,R5	; sum=sum*10;
	MUL R5,R6,R5	; sum=sum*10;
	LDR R11,=0		;	//Reset to zero to hold quotient number
while
	CMP R5, R7		;while (total sum of numbers>= count)
	BLO endwhile	;{
	ADD R11,R11,#1	;quotient++
	SUB R5,R5,R7	;remainder = remainder - b
	B 	while		;}
endwhile	
	MOV R7,R8		;	//Moving the count to R7 to free up R8
backtoprint			;	//backtoprint - Branch used to jump back to print a different value - Used multiple times near end of program
	LDR R5,=9		; 9 - Max power of base 10 - 10^9 = 1,000,000,000 - 1 Billion Max power of ten possible.
	LDR R12,=0		; quotient = 0;
	LDR R3,=0		; baseTenPowerCounter = 0;
decimalprinting
whileprinting

	LDR R8,=1       ; resultOfTenToThePower = 1;
	CMP R5,#1		; if (maxPowerOfBaseTen == 1)
	BNE decimal		; {
	LDR R0,=0x2E	;	System.out.print(".")
	BL sendchar		;}
	LDR R3,=0		; baseTenPowerCounter = 0;
decimal
; Code produced by Conor Gildea in first year in 2016/2017.
tenpower
	CMP R5,#0			; if (maxPowerOfBaseTen != 0)
	BEQ digitone		;{
	CMP R5,#0xFFFFFFFF	; 	if (maxPowerOfBaseTen != -1) // Else it ends the division and printing and branches to line 176 of code
	BEQ enddivision		;	{
	CMP R3,R5			;		if (baseTenPowerCounter != maxPowerOfBaseTen)
	BEQ endtenpower		;		{
	MUL R8,R6,R8		;			resultOfTenToThePower = 10*resultOfTenToThePower //resultOfTenToThePower=1 at beginning of loop
	ADD R3,R3,#1		;			baseTenPowerCounter = baseTenPowerCounter++
	B 	tenpower		;		}
endtenpower				;	}
digitone				;}
	CMP R11,R8					;if (mean/range/min/max/sumOfTotals > resultOfTenToThePower)
	BLO endbeforedividingloop	;{
	LDR R12,=0					;	//Reset hexademical value to be printed
whiledividing
	CMP R11,R8					;	while(mean/range/min/max/sumOfTotals > resultOfTenToThePower)
	BLO enddividingloop			;	{
	SUB R11,R11,R8				;		(mean/range/min/max/sumOfTotals)-resultOfTenToThePower;
	ADD R12,R12,#1				;		 valueToBePrinted++;
	B 	whiledividing			;	}
enddividingloop					;}
	MOV R3,#0					;	//Reset baseCounter ; Code produced by Conor Gildea in first year in 2016/2017.
	SUB R5,R5,#1				;	maxPowerOfBaseTen - 1;		//This causes the loop to calculate decreasing powers of base 10.
	LDR R8,=1					;	resultOfTenToThePower = 1;	//Resets result of base 10 power loop.
	ADD R12,R12,#0x30			;	Turn into ASCII symbol value by adding hexademical 30
	MOV R0,R12					;	System.out.print(""+valueToBePrinted);
	BL 	sendchar				;
	B	restart					;//Branches to restart, to calculate the next value
endbeforedividingloop			; 	while(mean/range/min/max/sumOfTotals < resultOfTenToThePower)
	MOV R3,#0					;	{ //Reset baseCounter
	SUB R5,R5,#1				;	maxPowerOfBaseTen - 1;		//This causes the loop to calculate decreasing powers of base 10.
	LDR R8,=1					;	resultOfTenToThePower = 1;	//Resets result of base 10 power loop.
	CMP R12,#0					;	}
	BEQ nonsignificantnumber	; if (lastValueToBePrinted !=0x0) //After a first digit is displayed, this if statement 
								;								causes a zero to be displayed if necessary by checking was the last digit in R12 !=0x0
								;								If it wasn't =0x0 then this if statement prints a zero and resets R12 to 0x30 to allow
								;								future zeros to be printed.
	LDR R12,=0					;	{
	ADD R12,R12,#0x30			;		valueToBePrinted = 0; //And add hexademical 0x30 to conver it to ASCII symbol
	MOV R0,R12					;		System.out.print(""+valueToBePrinted);
	BL sendchar					;	}
nonsignificantnumber	
restart	
	B	whileprinting
	
endloop
	B 	decimalprinting
	
endprogram
	B 	extraloop
				;//Code produced by Conor Gildea in first year in 2016/2017.
enddivision		;//Beyond this point I process the other statistical measures and then branch them back into the printing loop
				;//some measurements need a lot of additional attention before I branch them back in and I must be careful as
				;//the above printing loop was designed for the mean , thus I had to redo some of the code above, here.
				
	CMP R4,#1   		;if (stageOfPrinting == 1)
	BHS rangefinished	;{
	ADD R4,R4,#1		;	stageOfPrinting++;
	LDR R5,=2147483647	; 	wrapAroundPoint = 2147483647; //This is half of the max value that can be stored.
						; 							     //It is the wrapAroundPoint of the 2 Compliments system
	CMP R10,R5			;	if (minNumber>2147483647)
	BLT minusminrange	;	{
	MVN R10, R10		; 		value = NOT value (invert bits)
	ADD R10, R10, #1 	; 		value = value + 1 (add 1)
minusminrange			;	}

	CMP R9,R5			;	if (maxNumber>2147483647)
	BLT minusmaxrange	;	{
	MVN R9, R9			; 		value = NOT value (invert bits)
	ADD R9, R9, #1 		; 		value = value + 1 (add 1)
minusmaxrange			;	}

	SUBS R3,R9,R10		; 	range = maxValue - minValue;
	MOV R11,R3			; 	//Move Range to R11
	LDR R0,=range		;	System.out.print("\nRange:")
	BL fputs
	MUL R11,R6,R11		;   range = range*100;
	MUL R11,R6,R11		;	//By multiplying by 100 we can work out up to two decimal places
	B backtoprint		;   //Branches back up to backtoprint, printing the range and then eventually arrives below this code
rangefinished			;}

; Code produced by Conor Gildea in first year in 2016/2017.

	CMP R4,#2				;if (stageOfPrinting == 2)
	BHS sumoftotalsfinished	;{
	ADD R4,R4,#1			;	stageOfPrinting++;
	MOV R11,R7				;	//Move sumOfTotals to R11 - R11 - Register used in printing loop
	LDR R0,=sumoftotals		;	System.out.print("\nSum of totals:");
	BL fputs
	LDR R5,=2147483647		;	wrapAroundPoint = 2147483647 //This is half of the max value that can be stored.
							; 							 	 //It is the wrapAroundPoint of the 2 Compliments system
	CMP R11,R5				;	if (sumOfTotals>2147483647)
	BLS negativesumofTotals	;	{
	MVN R11, R11 			; 		value = NOT value (invert bits)
	ADD R11, R11, #1 		; 		value = value + 1 (add 1)
	MOV R0,#0x2D			;   	System.out.print("-");
	BL sendchar				;	}
negativesumofTotals			;
	MUL R11,R6,R11			; 	sumOfTotals*100
	MUL R11,R6,R11			;	//By multiplying by 100 we can work out up to two decimal places
	B backtoprint			;   //Branches back up to backtoprint, printing the range and then eventually arrives below this code
sumoftotalsfinished			;}


	CMP R4,#3				;if (stageOfPrinting == 3)
	BHS min					;{
	ADD R4,R4,#1			;	stageOfPrinting++;
	MOV R11,R10				;	//Move into register for printing loop
	LDR R0,=minNo			;	System.out.print("\nMin:");
	BL fputs				;
	LDR R5,=2147483647		;	wrapAroundPoint = 2147483647 //This is half of the max value that can be stored.
							; 							  //It is the wrapAroundPoint of the 2 Compliments system
							; Code produced by Conor Gildea in first year in 2016/2017.
	CMP R11,R5				;	if (sumOfTotals>2147483647)
	BLS negativemin			;	{
	MVN R11, R11 			; 		value = NOT value (invert bits)
	ADD R11, R11, #1 		; 		value = value + 1 (add 1)
	MOV R0,#0x2D			;   	System.out.print("-");
	BL sendchar				;	}
negativemin					;
	MUL R11,R6,R11			; 	minNumber*100
	MUL R11,R6,R11			;	//By multiplying by 100 we can work out up to two decimal places
	B backtoprint			;	//Branches back up to backtoprint, printing the range and then eventually arrives below this code
min							;}

	CMP R4,#4				;if (stageOfPrinting == 4)
	BHS max					;{
	ADD R4,R4,#1			;	stageOfPrinting++;
	MOV R11,R9				;	//Move into register for printing loop
	LDR R0,=maxNo			;	System.out.print("\nMax:");
	BL fputs				;
	LDR R5,=2147483647		;	wrapAroundPoint = 2147483647 //This is half of the max value that can be stored.
							; 							  //It is the wrapAroundPoint of the 2 Compliments system
	CMP R11,R5				; 	if (sumOfTotals>2147483647)
	BLS negativemax			;	{
	MVN R11, R11 			; 		value = NOT value (invert bits)
	ADD R11, R11, #1 		; 		value = value + 1 (add 1)
	MOV R0,#0x2D			; 		System.out.print("-");
	BL sendchar				;	}
negativemax					;
	MUL R11,R6,R11			; 	maxNumber*100
	MUL R11,R6,R11			; 	//By multiplying by 100 we can work out up to two decimal places
	B backtoprint			; 	//Branches back up to backtoprint, printing the range and then eventually arrives below this code
max							;}
	B loop
endprograminvalid1
endprograminvalid2
		LDR R0,=invalidinput;	System.out.print("\nInvalid Input, please restart and enter valid input.");
		BL fputs
		
		; Code produced by Conor Gildea in first year in 2016/2017.

stop	B 		stop
        AREA	MyStrings, DATA, READONLY
hi			DCB	"Please enter your list of values. Hit 'enter' after each value is entered \nand press '.' when you are finished entering your list of values.\n",0
mean		DCB	"\nMean:",0
sumoftotals DCB "\nSum:",0
maxNo    	DCB "\nMax:",0
minNo		DCB "\nMin:",0
range		DCB "\nRange:",0
invalidinput DCB "\nInvalid Input, please restart and enter valid input.",0
        END
