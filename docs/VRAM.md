# VRAM Map

```
 ---------------------------------------------
////   Location of stuff in SMW's VRAM	   \\\\
||| for levels, overworld, and boss battles |||
\\\    in both a clean and modded ROM	   ////
 --------------------------------by Ladida----
```

### LEVELS (LM 1.7+)

|    Thing	| 	 VRAM Address		| Specifications
---------------:|:-----------------------------:|:---------------
Layer 1/2 (FG1):|	`$0000 - $07FF`|		4bpp
Layer 1/2 (FG2):|	`$0800 - $0FFF`|		4bpp
Layer 1/2 (BG1):|	`$1000 - $17FF`|		4bpp
Layer 1/2 (FG3):|	`$1800 - $1FFF`|		4bpp
Layer 1/2 (BG2):|	`$2000 - $27FF`|		4bpp
Layer 1/2 (BG3):|	`$2800 - $2FFF`|		4bpp
|||
Layer 1 Tilemap:|	`$3000 - $37FF`|		512x256
Layer 2 Tilemap:|	`$3800 - $3FFF`|		512x256
|||
Layer 3 (GFX 28):|	`$4000 - $43FF`|		2bpp
Layer 3 (GFX 29):|	`$4400 - $47FF`|		2bpp
Layer 3 (GFX 2A):|	`$4800 - $4BFF`|		2bpp
Layer 3 (GFX 2B):|	`$4C00 - $4FFF`|		2bpp
|||
Layer 3 Tilemap:|	`$5000 - $5FFF`|		512x512
|||
Sprites (SP1):|		`$6000 - $67FF`|		4bpp
Sprites (SP2):|		`$6800 - $6FFF`|		4bpp
Sprites (SP3):|		`$7000 - $77FF`|		4bpp
Sprites (SP4):|		`$7800 - $7FFF`|		4bpp



### OVERWORLD AND CREDITS [AND ORIGINAL SMW LEVELS]

|    Thing	| 	 VRAM Address		| Specifications
---------------:|:-----------------------------:|:---------------
Layer 1/2 (FG1 [FG1]):|	`$0000 - $07FF`|		4bpp
Layer 1/2 (FG2 [FG2]):|	`$0800 - $0FFF`|		4bpp
Layer 1/2 (FG3 [BG1]):|	`$1000 - $17FF`|		4bpp
Layer 1/2 (FG4 [FG3]):|	`$1800 - $1FFF`|		4bpp
|||
Layer 1 Tilemap:|	`$2000 - $2FFF`|		512x512
Layer 2 Tilemap:|	`$3000 - $3FFF`|		512x512
|||
Layer 3 (GFX 28):|	`$4000 - $43FF`|		2bpp
Layer 3 (GFX 29):|	`$4400 - $47FF`|		2bpp
Layer 3 (GFX 2A):|	`$4800 - $4BFF`|		2bpp
Layer 3 (GFX 2B):|	`$4C00 - $4FFF`|		2bpp
|||
Layer 3 Tilemap:|	`$5000 - $5FFF`|		512x512
|||
Sprites (SP1):|		`$6000 - $67FF`|		4bpp
Sprites (SP2):|		`$6800 - $6FFF`|		4bpp
Sprites (SP3):|		`$7000 - $77FF`|		4bpp
Sprites (SP4):|		`$7800 - $7FFF`|		4bpp




### BOSS BATTLES

|    Thing	| 	 VRAM Address		| Specifications
---------------:|:-----------------------------:|:---------------
Layer 1 (GFX/Tile):|	`$0000 - $3FFF`|		8bpp planar
|||
Layer 3 (GFX 28):|	`$4000 - $43FF`|		2bpp
Layer 3 (GFX 29):|	`$4400 - $47FF`|		2bpp
Layer 3 (GFX 2A):|	`$4800 - $4BFF`|		2bpp
Layer 3 (GFX 2B):|	`$4C00 - $4FFF`|		2bpp
|||
Layer 3 Tilemap:|	`$5000 - $5FFF`|		512x512
|||
Sprites (SP1):|		`$6000 - $67FF`|		4bpp
Sprites (SP2):|		`$6800 - $6FFF`|		4bpp
Sprites (SP3):|		`$7000 - $77FF`|		4bpp
Sprites (SP4):|		`$7800 - $7FFF`|		4bpp

