; Example for invoking the SA-1 CPU

snes:
	; Set 24-bit pointer to execute SA-1 code.
	LDA.b #sa1_code
	STA $3180
	LDA.b #sa1_code>>8
	STA $3181
	LDA.b #sa1_code>>16
	STA $3182
	
	; Call and wait for the SA-1 CPU.
	JSR $1E80
	
	; Return
	RTS

sa1_code:
	PHB
	PHK
	PLB
	; Execute your SA-1 code here.
	PLB
	RTL
