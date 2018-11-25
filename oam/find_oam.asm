; Routine for finding a free OAM slot
; NMSTL compatible. Tested against Level ASM, Overworld ASM.

find_oam:
	LDY #$FC
-	LDA $02FD|!addr,y
	CMP #$F0
	BNE +
	CPY #$3C
	BEQ +
	DEY
	DEY
	DEY
	DEY
	BRA -
+	RTS
