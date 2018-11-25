; Standard Hex to Dec

hex_to_dec:
	LDX #$00
-	CMP #$0A
	BCC +
	SBC #$0A
	INX
	BRA -
+	RTL

; Hex to Dec (16-bit X/Y)

hex_to_dec16:
	LDX #$0000
-	CMP #$0A
	BCC +
	SBC #$0A
	INX
	BRA -
+	RTL

; Hex to Dec (uses Y to count instead. 16-bit X/Y)

hex_to_dec_16y:
	LDY #$0000
-	CMP #$0A
	BCC +
	SBC #$0A
	INY
	BRA -
+	RTL
