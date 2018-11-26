; by Akaginite
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GetAtan2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
; This routine will get angle between two points.
;
; Input:
; $00-$01 X-Distance
; $02-$03 Y-Distance
;
; Output:
; $00-$01 Angle (0x0000-0x01FF)
; $02-$06 will be destructed.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GetAtan2:	REP #$20
		LDY #$00
		LDA $00			;\
		BPL .X_Plus		; |
		LDY #$04		; |
		EOR.w #$FFFF		; | Get absolute value of X
		INC A			; |
		STA $00			;/
.X_Plus		LDA $02			;\
		BPL .Y_Plus		; |
		INY #2			; |
		EOR.w #$FFFF		; | Get absolute value of Y
		INC A			; |
		STA $02			;/
.Y_Plus		CMP $00			;\ If X is smaller than Y...
		BCC +			;/
		STA $04			;\
		LDA $00			; |
		STA $02			; | swap X and Y.
		LDA $04			; |
		STA $00			; |
		INY			;/
+		STY $06			;
		LDA $02			;
		STA $04			;
		STZ $02			;
		ORA $00			;
		AND.w #$FF00		;
		BEQ .Next		;
		XBA			;
-		LSR $00			;
		LSR $04			;
		ROR $02			;
		LSR A			;
		BNE -			;
.Next		LDY $00			;
		BEQ .DivZero		;
		LDA $03			;
		STA $4204		;
		STY $4206		;
		SEP #$20		;\
		STZ $01			; |
		LDA #$40		; | Wait 16 cycles...
		CPY $03			; |
		BEQ +			; |
		BRA $00			;/
		LDY $4214		;
		LDA.w AtanTable,y	;
+		LSR $06			;
		BCC +			;
		EOR #$7F		;
		INC A			;
+		LSR $06			;
		BCC +			;
		EOR #$FF		;
		INC A			;
		BEQ +			;
		INC $01			;
+		LSR $06			;
		BCC +			;
		EOR #$FF		;
		INC A			;
		BNE +			;
		INC $01			;
+		STA $00			;
		LDA #$FE		;
		TRB $01			;
		RTS			;
		
.DivZero	SEP #$20		;
		LDY #$00		;
		LDA $06			;
		LSR A			;
		BCS +			;
		LDY #$80		;
		LSR A			;
+		AND #$01		;
		STA $01			;
		STY $00			;
		RTS

AtanTable:
db $00,$00,$01,$01,$01,$02,$02,$02,$03,$03,$03,$03,$04,$04,$04,$05
db $05,$05,$06,$06,$06,$07,$07,$07,$08,$08,$08,$09,$09,$09,$0A,$0A
db $0A,$0A,$0B,$0B,$0B,$0C,$0C,$0C,$0D,$0D,$0D,$0E,$0E,$0E,$0E,$0F
db $0F,$0F,$10,$10,$10,$11,$11,$11,$12,$12,$12,$12,$13,$13,$13,$14
db $14,$14,$15,$15,$15,$15,$16,$16,$16,$17,$17,$17,$18,$18,$18,$18
db $19,$19,$19,$1A,$1A,$1A,$1A,$1B,$1B,$1B,$1C,$1C,$1C,$1C,$1D,$1D
db $1D,$1E,$1E,$1E,$1E,$1F,$1F,$1F,$1F,$20,$20,$20,$21,$21,$21,$21
db $22,$22,$22,$22,$23,$23,$23,$23,$24,$24,$24,$24,$25,$25,$25,$26
db $26,$26,$26,$27,$27,$27,$27,$28,$28,$28,$28,$29,$29,$29,$29,$2A
db $2A,$2A,$2A,$2A,$2B,$2B,$2B,$2B,$2C,$2C,$2C,$2C,$2D,$2D,$2D,$2D
db $2E,$2E,$2E,$2E,$2E,$2F,$2F,$2F,$2F,$30,$30,$30,$30,$30,$31,$31
db $31,$31,$32,$32,$32,$32,$32,$33,$33,$33,$33,$33,$34,$34,$34,$34
db $34,$35,$35,$35,$35,$35,$36,$36,$36,$36,$36,$37,$37,$37,$37,$37
db $38,$38,$38,$38,$38,$39,$39,$39,$39,$39,$39,$3A,$3A,$3A,$3A,$3A
db $3B,$3B,$3B,$3B,$3B,$3B,$3C,$3C,$3C,$3C,$3C,$3D,$3D,$3D,$3D,$3D
db $3D,$3E,$3E,$3E,$3E,$3E,$3E,$3F,$3F,$3F,$3F,$3F,$3F,$40,$40,$40
