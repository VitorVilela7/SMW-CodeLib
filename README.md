# SMW-CodeLib
Repository for storing common/shared useful codes for SMW modding.

Feel free to contribute at will! The more, the better. Learn more at [CONTRIBUTING](CONTRIBUTING.md)

# ASM Code

## Graphics
- [Decompress GFX file](asm/gfx/decomp.asm) by Vitor Vilela
- [Decode SNES planar format to bitmap](asm/gfx/snes_graphics.asm) by Vitor Vilela

## Map16

- [Get acts like from map16 number](asm/map16/get_act_like.asm) by Vitor Vilela

## Math

- [Aiming routine](asm/math/aiming.asm) by MarioE
- [Aiming/Atan2 routine](asm/math/atan2.asm) by Akaginite
- [Fast 9-bit input sin/cos macro](asm/math/fast_sincos.asm) by Vitor Vilela
- [Hex to Dec routine](asm/math/hex_to_dec.asm) by Vitor Vilela
- [Standard 8-bit input sin/cos routine](asm/math/sincos.asm) by Vitor Vilela
- [Square root routine](asm/math/sqrt.asm) by MarioE

## OAM

- [Standard find OAM slot](asm/oam/find_oam.asm) by Vitor Vilela

## SA-1
- [Aiming/Atan2 routine](asm/sa1/atan2.asm) by Akaginite
- [Convert R/G/B from hue component (HSV/HSL algorithm)](asm/sa1/color.asm) by Vitor Vilela
- [Invoke SA-1 CPU from SNES CPU](asm/sa1/invoke_sa1.asm) by Vitor Vilela
- [Invoke SNES CPU from SA-1 CPU](asm/sa1/invoke_snes.asm) by Vitor Vilela
- [32-bit pseudo random number generator](asm/sa1/random.asm) by Vitor Vilela
- [32x32 graphics rotation routine](asm/sa1/rotate.asm) by Vitor Vilela
- [32x32 graphics rotate by y-axis routine](asm/sa1/rotate_yaxis.asm) by Vitor Vilela

## SRAM
- [Erase current save slot](asm/sram/erase.asm) by Sixtare
- [Clear layer 3 from VRAM](asm/vram/clear_layer3.asm) by Vitor Vilela

# Tool Code
Algorithms and codes for scripting and SMW tools designing.

## Graphics
- [TPL/MW3/PAL, SNES <-> HEX color algorithms C# code](cs/gfx/Color.cs) by Vitor Vilela
- [FuSoYa's Lunar Compress P/Invoke wrapper C# code](cs/gfx/LC.cs) by Vitor Vilela

### [SnesGFX base graphics engine C# code](cs/gfx/snesgfx) by Vitor Vilela
- [Interface for SnesGFX graphics type C# code](cs/gfx/snesgfx/IBitformat.cs)
- [Linear GFX algorithms C# code](cs/gfx/snesgfx/Linear.cs)
- [Packed GFX algorithms C# code](cs/gfx/snesgfx/Packed.cs)
- [Planar/Linear converter, 2/3/4/8/Mode7 converters C# code](cs/gfx/snesgfx/SNES.cs)
- [Main program base library C# code](cs/gfx/snesgfx/SnesGFX.cs)

## Music
- [Reverse engineer Addmusic4, HFD's Addmusic and AddmusicM SPC algorithm C# code](cs/music/AntiSPC.cs) by Vitor Vilela
- [Decode BRR file C# code](cs/music/BRR.cs) by Vitor Vilela
- [Convert SPC to N-SPC volume C# code](cs/music/VolumeCalc.cs) by Vitor Vilela

# Docs
Diagrams, references, datasheets, maps, etc.

## Maps
- [SRAM](docs/SRAM.md) by Lui37
- [VRAM](docs/VRAM.md) by Ladida
