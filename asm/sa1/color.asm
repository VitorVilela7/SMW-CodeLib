; Color-related library.

convert_hue:
	rep #$20
	sta $04
	jsl Sin
	clc
	adc #$0100
	lsr
	adc #$0000
	cmp #$0100
	bcc +
	lda #$00ff
+	sep #$20
	sta $00
	
	rep #$20
	lda $04
	clc
	adc #$0055
	jsl Sin
	clc
	adc #$0100
	lsr
	adc #$0000
	cmp #$0100
	bcc +
	lda #$00ff
+	sep #$20
	sta $02
	
	rep #$20
	lda $04
	clc
	adc #$00ab
	jsl Sin
	clc
	adc #$0100
	lsr
	adc #$0000
	cmp #$0100
	bcc +
	lda #$00ff
+	sep #$20
	sta $04
	rtl
	
; gets r, g, b [0..255] $00-$05 component of specified hue in A [0..255]
; more accurate version

convert_hue2:				; Convert pure hue to RGB

	PHB				; \ Setup data bank.
	PHK				;  |
	PLB				; /

	XBA				; Save hue value
	LDA #$01			; \ Division mode
	STA $2250			; /
	REP #$20			; \ Divide (hue << 7)
	LSR				;  |
	STA $2251			; /
	LDA #$1556			; \ by 60° (2^15/360)
	STA $2253			; /
	
	PHX				; \ Preserve X/Y
	PHY				; / while waiting.
	
	LDA $2308			; \ Multiply remainder by 12
	ASL				;  |
	ADC $2308			;  |
	ASL #2				; /
	SEP #$20			; \ Then divide by 256
	XBA				; /
	
	LDY $2306			; Load index
	
	LSR $2306			; \ Swap value if index
	BCC +				;  | is on decrease mode. (x&1)
	EOR #$FF			;  |
	INC				; /
+
	LDX .table2,y			; \ Store decrement/increase value
	STA $00,x			; /
	LDX .table3,y			; \ Store zero value
	STZ $00,x			; /
	LDA #$FF			; \ Store full value
	LDX .table1,y			;  |
	STA $00,x			; /
	
	PLY				; \ Restore Y/X/B and return.
	PLX				;  |
	PLB				;  |
	RTL				; /
	
.table1
	db $00,$02,$02,$04,$04,$00
.table2
	db $02,$00,$04,$02,$00,$04
.table3
	db $04,$04,$00,$00,$02,$02
	

Sin:
	CLC
	ADC #$00C0
;cos:
	PHX
	REP #$10
	AND #$00FF
	ASL
	TAX
	LDA.l CosTable,x
	SEP #$10
	PLX
	RTL

CosTable:
dw $0100,$0100,$0100,$00FF,$00FF,$00FE,$00FD,$00FC,$00FB,$00FA,$00F8,$00F7,$00F5,$00F3,$00F1,$00EF
dw $00ED,$00EA,$00E7,$00E5,$00E2,$00DF,$00DC,$00D8,$00D5,$00D1,$00CE,$00CA,$00C6,$00C2,$00BE,$00B9
dw $00B5,$00B1,$00AC,$00A7,$00A2,$009D,$0098,$0093,$008E,$0089,$0084,$007E,$0079,$0073,$006D,$0068
dw $0062,$005C,$0056,$0050,$004A,$0044,$003E,$0038,$0032,$002C,$0026,$001F,$0019,$0013,$000D,$0006
dw $0000,$FFFA,$FFF3,$FFED,$FFE7,$FFE1,$FFDA,$FFD4,$FFCE,$FFC8,$FFC2,$FFBC,$FFB6,$FFB0,$FFAA,$FFA4
dw $FF9E,$FF98,$FF93,$FF8D,$FF87,$FF82,$FF7C,$FF77,$FF72,$FF6D,$FF68,$FF63,$FF5E,$FF59,$FF54,$FF4F
dw $FF4B,$FF47,$FF42,$FF3E,$FF3A,$FF36,$FF32,$FF2F,$FF2B,$FF28,$FF24,$FF21,$FF1E,$FF1B,$FF19,$FF16
dw $FF13,$FF11,$FF0F,$FF0D,$FF0B,$FF09,$FF08,$FF06,$FF05,$FF04,$FF03,$FF02,$FF01,$FF01,$FF00,$FF00
dw $FF00,$FF00,$FF00,$FF01,$FF01,$FF02,$FF03,$FF04,$FF05,$FF06,$FF08,$FF09,$FF0B,$FF0D,$FF0F,$FF11
dw $FF13,$FF16,$FF19,$FF1B,$FF1E,$FF21,$FF24,$FF28,$FF2B,$FF2F,$FF32,$FF36,$FF3A,$FF3E,$FF42,$FF47
dw $FF4B,$FF4F,$FF54,$FF59,$FF5E,$FF63,$FF68,$FF6D,$FF72,$FF77,$FF7C,$FF82,$FF87,$FF8D,$FF93,$FF98
dw $FF9E,$FFA4,$FFAA,$FFB0,$FFB6,$FFBC,$FFC2,$FFC8,$FFCE,$FFD4,$FFDA,$FFE1,$FFE7,$FFED,$FFF3,$FFFA
dw $0000,$0006,$000D,$0013,$0019,$001F,$0026,$002C,$0032,$0038,$003E,$0044,$004A,$0050,$0056,$005C
dw $0062,$0068,$006D,$0073,$0079,$007E,$0084,$0089,$008E,$0093,$0098,$009D,$00A2,$00A7,$00AC,$00B1
dw $00B5,$00B9,$00BE,$00C2,$00C6,$00CA,$00CE,$00D1,$00D5,$00D8,$00DC,$00DF,$00E2,$00E5,$00E7,$00EA
dw $00ED,$00EF,$00F1,$00F3,$00F5,$00F7,$00F8,$00FA,$00FB,$00FC,$00FD,$00FE,$00FF,$00FF,$0100,$0100