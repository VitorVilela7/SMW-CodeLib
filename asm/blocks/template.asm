db $42 ; or db $37
JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP TopCorner : JMP BodyInside : JMP HeadInside
; JMP WallFeet : JMP WallBody ; if using db $37

MarioBelow:
MarioAbove:
MarioSide:

TopCorner:
BodyInside:
HeadInside:

WallFeet:
WallBody:

SpriteV:
SpriteH:

MarioCape:
MarioFireball:
RTL
