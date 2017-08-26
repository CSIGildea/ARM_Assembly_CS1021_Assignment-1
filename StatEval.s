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
				;					when you are finished entering your list of values.\n");
	BL	fputs	; Code produced by Conor Gildea in first year in 2016/2017.
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
	BL sendchar					;
	CMP R12,#1					;if (negativeNumber=true) 	//Converts negative numbers to 2 Compliment Form
	BNE negativenumberchange	;{
	MVN R4, R4 					; 	value = NOT value (invert bits)
	ADD R4, R4, #1 				; 	value = value + 1 (add 1)	
negativenumberchange			;}
	MOV R12,#0					; negativeNumber = false;
	ADD R7,R7,#1    			; count++; 					//Calculating the count in R7
	ADD R8,R8,R4    			; sum = sum + value; 		//Calculating the sum in R8		
	
	
	CMP R7,#1				; if (count==1)
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

	MOV R5,R8				; newDigitRegistry = sum //As the sum moved to R5, R5 will now be refered to as the variable sum
	LDR R0,=mean			; System.out.print("\nMean:);
	BL fputs				;
	LDR R11,=2147483647		; wrapAroundPoint = 2147483647 //This is half of the max value that can be stored.
							; 							   //It is the wrapAroundPoint of the 2 Compliments system
							; Code produced by Conor Gildea in first year in 2016/2017.
	CMP R5,R11
	BLO negative			; if(sum>warpAroundPoint)      //If sum is negative it converts it back to unsigned numbers 
							;{									to display properly
	MVN R5, R5 				; value = NOT value (invert bits)
	ADD R5, R5, #1 			; value = value + 1 (add 1)
	MOV R0,#0x2D			; System.out.print("-")
	BL sendchar				;}

negative
	LDR R11,=0		;	//Reset to zero to hold quotient number
while
	CMP R5, R7		;while (total sum of numbers>= count)
	BLO endwhile	;{
	ADD R11,R11,#1	;quotient++
	SUB R5,R5,R7	;remainder = remainder - count
	B 	while		;}
endwhile
	CMP R0,#0x2D
	BLO negativemean		; if(sum>warpAroundPoint)      //If sum is negative it converts it back to unsigned numbers 
							;{									to display properly
	MVN R11, R11 			; 	value = NOT value (invert bits)
	ADD R11, R11, #1 		; 	value = value + 1 (add 1)
	BL sendchar				;}
negativemean
	LDR R5,=2147483647	; 	wrapAroundPoint = 2147483647; //This is half of the max value that can be stored.
						; 							     //It is the wrapAroundPoint of the 2 Compliments system
						; Code produced by Conor Gildea in first year in 2016/2017.
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
endprogram
	B loop
endprograminvalid1
endprograminvalid2
		LDR R0,=invalidinput;	System.out.print("\nInvalid Input, please restart and enter valid input.");
		BL fputs

stop	B 		stop
        AREA	MyStrings, DATA, READONLY
hi			DCB	"Please enter your list of values. Hit 'enter' after each value is entered \nand press '.' when you are finished entering your list of values.\n",0
mean		DCB	"\nMean:",0
invalidinput DCB "\nInvalid Input, please restart and enter valid input.",0
        END