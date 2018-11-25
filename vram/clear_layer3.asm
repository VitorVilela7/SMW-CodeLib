; Clear Layer 3 Image on VRAM.

clear_layer3:
	REP #$20
	LDA #$5100
	STA $2116
	LDY #$80
	STY $2115
	LDA #$1809
	STA $4300
	LDA #.zero
	STA $4302
	LDY.b #.zero>>16
	STY $4304
	LDA #$2000-$0200
	STA $4305
	LDY #$01
	STY $420B
	SEP #$20
	RTL
.zero
	db $FC
