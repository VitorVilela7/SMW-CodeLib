; Erase current save file
; by Sixtare

Erase:
REP #$10
	LDA $010A
	CMP #$01
	BEQ .01
	BCS .02
.00
LDX #$008F
JMP .delete

.01
LDX #$011E
JMP .delete

.02
LDX #$01AD
	.delete
	LDY #$008F
	LDA #$00
-	STA $700000,x
	STA $7001AD,x
	DEX
	DEY
	BPL -
	SEP #$10
RTS
