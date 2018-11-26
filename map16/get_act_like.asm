; $00 = map16 tile
get_act_like:
	LDA $06F624
	STA $02
	LDA $06F625
	STA $03
	LDA $06F626
	STA $04
	
	REP #$30
	LDA $00
	AND #$3FFF
	ASL
	TAY
	LDA [$02],y
	STA $00
	SEP #$30
	RTS
