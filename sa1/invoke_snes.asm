; Example for invoking the SNES CPU from SA-1 CPU.

sa1:
	; Set 24-bit pointer to execute SNES code.
	LDA.b #snes_code
	STA $0183
	LDA.b #snes_code>>8
	STA $0184
	LDA.b #snes_code>>16
	STA $0185
	
	; Invoke the SNES CPU.
	LDA #$D0
	STA $2209

	; Wait until the SNES CPU finishes processing.
.wait	
	LDA $018A
	BEQ .wait
	STZ $018A
	
	; Return
	RTS

snes_code:
	PHB
	PHK
	PLB
	; Execute your SNES CPU code here.
	PLB
	RTL
