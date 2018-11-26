; Fast Trigonometric Table/Macro
; Twice precision compared to sincos.asm
; Input: 0 - 511 (16-bit)
; Output: 8.8 signed fixed point

macro sin()
	phx
	rep #$10
	and #$01ff
	asl
	tax
	lda.w sin_table,x
	sep #$10
	plx
endmacro

macro cos()
	phx
	rep #$10
	and #$01ff
	asl
	tax
	lda.w cos_table,x
	sep #$10
	plx
endmacro

sin_table:
dw $0000,$0003,$0006,$0009,$000d,$0010,$0013,$0016,$0019,$001c,$001f,$0022,$0026,$0029,$002c,$002f
dw $0032,$0035,$0038,$003b,$003e,$0041,$0044,$0047,$004a,$004d,$0050,$0053,$0056,$0059,$005c,$005f
dw $0062,$0065,$0068,$006b,$006d,$0070,$0073,$0076,$0079,$007b,$007e,$0081,$0084,$0086,$0089,$008c
dw $008e,$0091,$0093,$0096,$0098,$009b,$009d,$00a0,$00a2,$00a5,$00a7,$00aa,$00ac,$00ae,$00b1,$00b3
dw $00b5,$00b7,$00b9,$00bc,$00be,$00c0,$00c2,$00c4,$00c6,$00c8,$00ca,$00cc,$00ce,$00cf,$00d1,$00d3
dw $00d5,$00d7,$00d8,$00da,$00dc,$00dd,$00df,$00e0,$00e2,$00e3,$00e5,$00e6,$00e7,$00e9,$00ea,$00eb
dw $00ed,$00ee,$00ef,$00f0,$00f1,$00f2,$00f3,$00f4,$00f5,$00f6,$00f7,$00f8,$00f8,$00f9,$00fa,$00fa
dw $00fb,$00fc,$00fc,$00fd,$00fd,$00fe,$00fe,$00fe,$00ff,$00ff,$00ff,$0100,$0100,$0100,$0100,$0100
cos_table:
dw $0100,$0100,$0100,$0100,$0100,$0100,$00ff,$00ff,$00ff,$00fe,$00fe,$00fe,$00fd,$00fd,$00fc,$00fc
dw $00fb,$00fa,$00fa,$00f9,$00f8,$00f8,$00f7,$00f6,$00f5,$00f4,$00f3,$00f2,$00f1,$00f0,$00ef,$00ee
dw $00ed,$00eb,$00ea,$00e9,$00e7,$00e6,$00e5,$00e3,$00e2,$00e0,$00df,$00dd,$00dc,$00da,$00d8,$00d7
dw $00d5,$00d3,$00d1,$00cf,$00ce,$00cc,$00ca,$00c8,$00c6,$00c4,$00c2,$00c0,$00be,$00bc,$00b9,$00b7
dw $00b5,$00b3,$00b1,$00ae,$00ac,$00aa,$00a7,$00a5,$00a2,$00a0,$009d,$009b,$0098,$0096,$0093,$0091
dw $008e,$008c,$0089,$0086,$0084,$0081,$007e,$007b,$0079,$0076,$0073,$0070,$006d,$006b,$0068,$0065
dw $0062,$005f,$005c,$0059,$0056,$0053,$0050,$004d,$004a,$0047,$0044,$0041,$003e,$003b,$0038,$0035
dw $0032,$002f,$002c,$0029,$0026,$0022,$001f,$001c,$0019,$0016,$0013,$0010,$000d,$0009,$0006,$0003
dw $0000,$fffd,$fffa,$fff7,$fff3,$fff0,$ffed,$ffea,$ffe7,$ffe4,$ffe1,$ffde,$ffda,$ffd7,$ffd4,$ffd1
dw $ffce,$ffcb,$ffc8,$ffc5,$ffc2,$ffbf,$ffbc,$ffb9,$ffb6,$ffb3,$ffb0,$ffad,$ffaa,$ffa7,$ffa4,$ffa1
dw $ff9e,$ff9b,$ff98,$ff95,$ff93,$ff90,$ff8d,$ff8a,$ff87,$ff85,$ff82,$ff7f,$ff7c,$ff7a,$ff77,$ff74
dw $ff72,$ff6f,$ff6d,$ff6a,$ff68,$ff65,$ff63,$ff60,$ff5e,$ff5b,$ff59,$ff56,$ff54,$ff52,$ff4f,$ff4d
dw $ff4b,$ff49,$ff47,$ff44,$ff42,$ff40,$ff3e,$ff3c,$ff3a,$ff38,$ff36,$ff34,$ff32,$ff31,$ff2f,$ff2d
dw $ff2b,$ff29,$ff28,$ff26,$ff24,$ff23,$ff21,$ff20,$ff1e,$ff1d,$ff1b,$ff1a,$ff19,$ff17,$ff16,$ff15
dw $ff13,$ff12,$ff11,$ff10,$ff0f,$ff0e,$ff0d,$ff0c,$ff0b,$ff0a,$ff09,$ff08,$ff08,$ff07,$ff06,$ff06
dw $ff05,$ff04,$ff04,$ff03,$ff03,$ff02,$ff02,$ff02,$ff01,$ff01,$ff01,$ff00,$ff00,$ff00,$ff00,$ff00
dw $ff00,$ff00,$ff00,$ff00,$ff00,$ff00,$ff01,$ff01,$ff01,$ff02,$ff02,$ff02,$ff03,$ff03,$ff04,$ff04
dw $ff05,$ff06,$ff06,$ff07,$ff08,$ff08,$ff09,$ff0a,$ff0b,$ff0c,$ff0d,$ff0e,$ff0f,$ff10,$ff11,$ff12
dw $ff13,$ff15,$ff16,$ff17,$ff19,$ff1a,$ff1b,$ff1d,$ff1e,$ff20,$ff21,$ff23,$ff24,$ff26,$ff28,$ff29
dw $ff2b,$ff2d,$ff2f,$ff31,$ff32,$ff34,$ff36,$ff38,$ff3a,$ff3c,$ff3e,$ff40,$ff42,$ff44,$ff47,$ff49
dw $ff4b,$ff4d,$ff4f,$ff52,$ff54,$ff56,$ff59,$ff5b,$ff5e,$ff60,$ff63,$ff65,$ff68,$ff6a,$ff6d,$ff6f
dw $ff72,$ff74,$ff77,$ff7a,$ff7c,$ff7f,$ff82,$ff85,$ff87,$ff8a,$ff8d,$ff90,$ff93,$ff95,$ff98,$ff9b
dw $ff9e,$ffa1,$ffa4,$ffa7,$ffaa,$ffad,$ffb0,$ffb3,$ffb6,$ffb9,$ffbc,$ffbf,$ffc2,$ffc5,$ffc8,$ffcb
dw $ffce,$ffd1,$ffd4,$ffd7,$ffda,$ffde,$ffe1,$ffe4,$ffe7,$ffea,$ffed,$fff0,$fff3,$fff7,$fffa,$fffd
dw $0000,$0003,$0006,$0009,$000d,$0010,$0013,$0016,$0019,$001c,$001f,$0022,$0026,$0029,$002c,$002f
dw $0032,$0035,$0038,$003b,$003e,$0041,$0044,$0047,$004a,$004d,$0050,$0053,$0056,$0059,$005c,$005f
dw $0062,$0065,$0068,$006b,$006d,$0070,$0073,$0076,$0079,$007b,$007e,$0081,$0084,$0086,$0089,$008c
dw $008e,$0091,$0093,$0096,$0098,$009b,$009d,$00a0,$00a2,$00a5,$00a7,$00aa,$00ac,$00ae,$00b1,$00b3
dw $00b5,$00b7,$00b9,$00bc,$00be,$00c0,$00c2,$00c4,$00c6,$00c8,$00ca,$00cc,$00ce,$00cf,$00d1,$00d3
dw $00d5,$00d7,$00d8,$00da,$00dc,$00dd,$00df,$00e0,$00e2,$00e3,$00e5,$00e6,$00e7,$00e9,$00ea,$00eb
dw $00ed,$00ee,$00ef,$00f0,$00f1,$00f2,$00f3,$00f4,$00f5,$00f6,$00f7,$00f8,$00f8,$00f9,$00fa,$00fa
dw $00fb,$00fc,$00fc,$00fd,$00fd,$00fe,$00fe,$00fe,$00ff,$00ff,$00ff,$0100,$0100,$0100,$0100,$0100
