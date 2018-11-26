; Recommended usage: call decode_snes_gfx then blocks_to_linear2.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; decodes 4bpp snes gfx to raw format.
; note that dest is double size of source.
; $00-$02: source
; $03-$05: destination
; $06-$07: size
	
decode_snes_gfx:
	REP #$30
	DEC $03
	SEP #$20
	LDY #$0000
.loop
	PHY
	LDY #$0000
.loop2
	PHX
	LDX #$0007
.loop3
	PHY
	PHX
	REP #$20
	INC $03
	
	LDY #$0010
	LDA [$00],y
	STA $08
	LDY #$0000
	LDA [$00],y
	STA $0A
	
	CPX #$0000
	BEQ .no_shift
.shift_loop
	LSR $08
	LSR $0A
	DEX
	BNE .shift_loop
.no_shift
	LDA #$FEFE
	TRB $0A
	TRB $08
	SEP #$20
	
	LDA $09
	ASL
	ORA $08
	ASL
	ORA $0B
	ASL
	ORA $0A
	STA [$03]
	PLX
	PLY
	DEX
	BPL .loop3
	PLX
	
	REP #$20
	LDA $00
	CLC
	ADC #$0002
	STA $00
	SEP #$20
	INY
	INY
	CPY #$0010
	BNE .loop2
	
	PLY
	
	REP #$20
	TYA
	CLC
	ADC #$0010
	TAY
	LDA $00
	CLC
	ADC #$0010
	STA $00
	SEP #$20
	CPY $06
	BNE .loop
	SEP #$10
	RTL
	
;Converts the source gfx from "tile" to "linear" format.
;$00-$02: source
;$03-$05: destination
;$06-$07: number of tiles

blocks_to_linear:
	REP #$31
	STZ $08
	STZ $0C
	
.loop2
	LDA $0C			;if "page bound" is out of width, then go to another page
	BEQ .no_wrap
	BIT #$007F
	BNE .no_wrap
	ADC #$0380
	STA $0C
.no_wrap
	STZ $0A
	LDX #$003F
.loop
	LDA $0A			;de interleave stuff
	AND #$0007
	STA $0E
	
	LDA $0A
	AND.w #~$F007
	ASL #4
	ORA $0E
	ADC $0C
	STA $0E
	LDA $08
	ASL #6
	ADC $0A
	TAY
	
	SEP #$20
	LDA [$00],y
	LDY $0E
	STA [$03],y
	REP #$21
	
	INC $0A
	DEX
	BPL .loop
	
	LDA $0C
	ADC #$0008
	STA $0C
	INC $08
	LDA $08
	CMP $06
	BNE .loop2
	SEP #$30
	RTL
	
;Converts the source gfx from "tile" to "linear" format.
;$00-$02: source
;$03-$05: destination
;$06-$07: number of tiles

blocks_to_linear2:
	REP #$31
	STZ $08
	STZ $0C
	
.loop2
	LDA $0C			;if "page bound" is out of width, then go to another page
	BEQ .no_wrap
	BIT #$001F
	BNE .no_wrap
	ADC #$00E0
	STA $0C
.no_wrap
	STZ $0A
	LDX #$003F
.loop
	LDA $0A			;de interleave stuff
	AND #$0007
	STA $0E
	
	LDA $0A
	AND.w #~$C007
	ASL #2
	ORA $0E
	ADC $0C
	STA $0E
	LDA $08
	ASL #6
	ADC $0A
	TAY
	
	SEP #$20
	LDA [$00],y
	LDY $0E
	STA [$03],y
	REP #$21
	
	INC $0A
	DEX
	BPL .loop
	
	LDA $0C
	ADC #$0008
	STA $0C
	INC $08
	LDA $08
	CMP $06
	BNE .loop2
	SEP #$30
	RTL
