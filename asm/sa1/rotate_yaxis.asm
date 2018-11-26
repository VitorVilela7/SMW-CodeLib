;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; SA-1 32x32 "y axis" rotation
; parallel mode service

; turn off service: set $8b.7

; destination bw-ram "virtual ram" & bw-ram
!dest		= $600000+($3e00*2)	;stuff
!destbw		= $403e00

; temp ram ($e0-$ff)
!re		= $e0		;$e0-$e3 is reserved
!cos 		= $e4		;$e4-$e5 is cosine value
!dx 		= $e6		;$e6-$e7 is initial x
!x 		= $e8		;$e8-$e9 is current x
!y 		= $ea		;$ea-$eb is current y
!ly		= $ec		;$ec-$ed is reserved
!deg		= $ee		;8-bit degress.
!deg2		= $ef		;8-bit degress. (backup)
!ptr		= $f0		;$f0-$f2 is current pointer

parallel_main:
	phb
	phk
	plb
-	lda $8b
	bmi .end
	lda !deg2
	cmp !deg
	beq -
	sta !deg2
	jsr .rotate
	bra -
	
.end
	plb
	rtl

.rotate
	sei
	lda #$01
	sta $2250			; division
	
	rep #$30
	lda !deg
	and #$00ff
	asl
	tax
	lda.w .cos_table,x
	sta !cos		; grab cos
	
	lda #$7fff		; invert cos value. (1/x)
	sta $2251
	lda !cos
	bne +
	inc
+	bpl +
	eor #$ffff
	inc
+	sta $2253
	nop
	bra $00
	lda $2306
	asl
	cmp #$0c00		; make sure that A is
	bcc +			; small enough to
	lda #$0bff		; don't overflow
+	bit !cos
	bpl +
	eor #$ffff
	inc
+	sta !cos
	
	stz $2250		; multiply mode
	
	lda.w #$fff0		; set initial x
	sta $2251
	lda !cos
	sta $2253
	nop
	bra $00
	lda $2306
	clc
	adc #$1000
	sta !dx
	sta !x
	
	lda #!dest
	sta !ptr
	lda #!dest>>8
	sta !ptr+1
	cli
	
	phb
	pea $4040		; set bank to $40
	plb
	plb
	
	clc
	
	; this code gets looped 32*32 times.
	stz $e2
	stz !y
	lda #$001f
	sta !ly			; 'y' loop count
.y	ldy #$001f		; 'x' loop count
.x	lda !x
	adc !cos
	sta !x
	cmp #$2000
	bcs .out_of_range
	sta $e0
	lda !y
	ora $e1
	tax
	sep #$20
	lda $b000,x ;$40b000
.back	sta [!ptr]
	rep #$21
	inc !ptr
	dey			; loop x
	bpl .x
	lda !dx			; reset x to default
	sta !x
	lda !y			; increase y by 1
	adc #$0020
	sta !y
	dec !ly			; loop y
	bpl .y
	sep #$30
	plb
	rts
.out_of_range
	sep #$20
	lda #$00
	bra .back
	
.cos_table
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
