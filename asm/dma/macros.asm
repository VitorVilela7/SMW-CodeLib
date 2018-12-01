macro vramwrite(a, b, vram, loc, bank, byte)
PHP : REP #$20
LDX <a>
STX $2115
LDA #$<vram>
STA $2116

LDA <b>
STA $4310

LDA.w #<loc>
STA $4312
LDX.b #<bank>
STX $4314

LDA <byte>
STA $4315

LDX #$02
STX $420B
PLP
endmacro


macro wramwrite(wram, wbank, b, loc, bank, byte)
PHP : REP #$20
LDA.w #<wram>
STA $2181
LDX.b #<wbank>
STX $2183

LDA <b>
STA $4310

LDA.w #<loc>
STA $4312
LDX.b #<bank>
STX $4314

LDA <byte>
STA $4315

LDX #$02
STX $420B
PLP
endmacro


macro cgramwrite(a, loc, bank, byte)
PHP : REP #$20
LDX <a>
STX $2121

LDA #$2202
STA $4310

LDA.w #<loc>
STA $4312
LDX.b #<bank>
STX $4314

LDA <byte>
STA $4315

LDX #$02
STX $420B
PLP
endmacro


macro vramread(a, b, vram, loc, bank, byte)
PHP : REP #$20
LDX <a>
STX $2115
LDA #$<vram>
STA $2116
LDA $2139

LDA <b>
STA $4310

LDA.w #<loc>
STA $4312
LDX.b #<bank>
STX $4314

LDA <byte>
STA $4315

LDX #$02
STX $420B
PLP
endmacro


macro cgramread(a, loc, bank, byte)
PHP : REP #$20
LDX <a>
STX $2121

LDA #$3B82
STA $4310

LDA.w #<loc>
STA $4312
LDX.b #<bank>
STX $4314

LDA <byte>
STA $4315

LDX #$02
STX $420B
PLP
endmacro
