;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GetAtan2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
; This routine will get angle between two points.
; If two points distances are far than 2^(n+8),
; calculation accuracy will loss to 1/(n+1).
; 
; input:
; $00-$01 X-Distance
; $02-$03 Y-Distance
;
; output:
; $04-$05 Angle (0x0000-0x01FF)
;
; destroy:
; $00-$03, $06
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		PHX
		PHP
		SEP #$10
		REP #$20
		LDX #$00		;\
		LDA $02			; |
		BPL ?+			; | Get absolute value of Y-Distance
		EOR.w #$FFFF		; | Reduce angle from 0-359 to 0-179 degrees
		INC A			; |
		STA $02			; |
		LDX #$04		;/
?+		LDA $00			;\
		BPL ?+			; |
		EOR.w #$FFFF		; | Get absolute value of X-Distance
		INC A			; | Reduce angle from 0-179 to 0-89 degrees
		STA $00			; |
		INX #2			;/
?+		CMP $02			;\
		BCS ?+			; |
		STA $04			; |
		LDA $02			; | if |Y| bigger than |X|, swap them
		STA $00			; | Reduce angle from 0-89 to 0-45 degrees
		LDA $04			; |
		STA $02			; |
		INX			;/
?+		STX $06			;	
		
		LDA $02			;\
		STA $04			; |
		STZ $02			; |
		ORA $00			; |
		AND.w #$FF00		; |
		BEQ .Next		; | for reason on the hardware register bit limitation,
		XBA			; | distance values will trunc to half unless both got below 0x0100...
.TruncPrecise	LSR $00			; |
		LSR $04			; |
		ROR $02			; |
		LSR A			; |
		BNE .TruncPrecise	;/
		
.Next
		if !SA1
			LDX #$01		;
			STX $2250		;
			LDA $03			;
			STA $2251		;
			LDA $00			;
			BEQ .DivZero		;
			STA $2253		;
			SEP #$20		; 3
			STZ $05			; 6
			LDX $2306		; 9 (before read the result)
			LDA $2307		;
			BEQ ?+			;
			LDX #$FF		;
	?+		LDA.l .AtanTable,x	;
		else
			LDX $00			;
			BEQ .DivZero		;
			LDA $03			;
			STA $4204		;
			STX $4206		;
			SEP #$20		; 3
			STZ $05			; 6
			LDA #$40		; 8
			CPX $04			; 11
			BEQ ?+			; 13
			LDX $4214		; 16 (before read the result)
			LDA.l .AtanTable,x	;
		endif
		
?+		LSR $06			;\
		BCC ?+			; | Restore angle from 0-45 to 0-89 degrees
		EOR #$7F		; |
		INC A			;/
?+		LSR $06			;\
		BCC ?+			; |
		EOR #$FF		; | Restore angle from 0-89 to 0-179 degrees
		INC A			; |
		BNE ?+			; |
		INC $05			;/
?+		LSR $06			;\
		BCC ?+			; |
		EOR #$FF		; | Restore angle from 0-179 to 0-359 degrees
		INC A			; |
		BEQ ?+			; |
		INC $05			;/
?+		STA $04			;
		LDA #$FE		;
		TRB $05			;
		PLP			;
		PLX			;
		RTL			;
		
.DivZero	SEP #$20		;
		LDX #$80		;
		LDA $06			;
		LSR A			;
		BCC ?+			;
		LDX #$00		;
		LSR A			;
?+		AND #$01		;
		STA $05			;
		STX $04			;
		PLP			;
		PLX			;
		RTL			;

; ArcTan Lookup Table
; 256 bytes, 0-45 degrees
.AtanTable
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
