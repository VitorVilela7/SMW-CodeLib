; Decompress input GFX file
; Must be called from SNES CPU.
; SA-1 is automatically invoked on SA-1 Pack ROMs.

STZ $00
REP #$20
LDA #$7EAD	; destination buffer = $7EAD00
STA $01
LDA #$0080	; deoompress ExGFX80.bin ..
JSL $0FF900

