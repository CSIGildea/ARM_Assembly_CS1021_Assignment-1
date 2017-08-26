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
	MOV R12,#1				;			boolean negativeNumber = true  ; Code produced by Conor Gildea in first year in 2016/2017.
negativenumber				;		}
	B	read				; 	}
							;}
endRead
	MOV R0,#0x20				; System.out.print(" "); 	//Placing a space between each input after enter is pressed
	BL sendchar					;							//Code produced by Conor Gildea in first year in 2016/2017.
	CMP R12,#1					;if (negativeNumber=true) 	//Converts negative numbers to 2 Compliment Form
	BNE negativenumberchange	;{
	MVN R4, R4 					; 	value = NOT value (invert bits)
	ADD R4, R4, #1 				; 	value = value + 1 (add 1)	
negativenumberchange			;}
endprogram
	B	loop
endprograminvalid1
endprograminvalid2
		LDR R0,=invalidinput;	System.out.print("\nInvalid Input, please restart and enter valid input.");
		BL fputs
; Code produced by Conor Gildea in first year in 2016/2017.
stop	B	stop

	AREA	MyStrings, DATA, READONLY
hi			 DCB	"Please enter your list of values. Hit 'enter' after each value is entered \nand press '.' when you are finished entering your list of values.\n",0
invalidinput DCB "\nInvalid Input, please restart and enter valid input.",0
	END	