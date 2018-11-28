# Super Mario World SRAM Map
### (by Lui37)

Total size of SRAM used by the game is 858 bytes (`$70:0000`-`$70:0359`).

Each file uses 143 bytes, with the last two being the checksum complement (or whatever it's called).

Data of file A: `$70:0000`-`$70:008E`
Data of file B: `$70:008F`-`$70:011D`
Data of file C: `$70:011E`-`$70:01AC`

Copy of file A: `$70:01AD`-`$70:023B`
Copy of file B: `$70:023C`-`$70:02CA`
Copy of file C: `$70:02CB`-`$70:0359`

Address|Size|Mirrors|Type|Quick Description
-:|:-:|:-:|:-:|:-:|:-
`$70:0000`|96 bytes|`$7E:1EA2`|MARIO A|Overworld level setting flags.
`$70:0060`|15 bytes|`$7E:1F02`|MARIO A|Overworld event flags, bitwise.
`$70:006F`|1 byte|`$7E:1F11`|MARIO A|Current submap for Mario.
`$70:0070`|1 byte|`$7E:1F12`|MARIO A|Current submap for Luigi.
`$70:0071`|4 bytes|`$7E:1F13`|MARIO A|Player animation on the overworld
`$70:0075`|2 bytes|`$7E:1F17`|MARIO A|Overworld X position of Mario.
`$70:0077`|2 bytes|`$7E:1F19`|MARIO A|Overworld Y position of Mario.
`$70:0079`|2 bytes|`$7E:1F1B`|MARIO A|Overworld X position of Luigi.
`$70:007B`|2 bytes|`$7E:1F1D`|MARIO A|Overworld Y position of Luigi.
`$70:007D`|2 bytes|`$7E:1F1F`|MARIO A|Pointer to Mario's overworld X position.
`$70:007F`|2 bytes|`$7E:1F21`|MARIO A|Pointer to Mario's overworld Y position.
`$70:0081`|2 bytes|`$7E:1F23`|MARIO A|Pointer to Luigi's overworld X position.
`$70:0083`|2 bytes|`$7E:1F25`|MARIO A|Pointer to Luigi's overworld Y position.
`$70:0085`|4 bytes|`$7E:1F27`|MARIO A|Switch block flags (Green, Yellow, Blue and Red).
`$70:0089`|3 bytes|`$7E:1F2B`|MARIO A|Empty. Cleared at reset and titlescreen load.
`$70:008C`|1 byte|`$7E:1F2E`|MARIO A|Number of events triggered.
`$70:008D`|2 bytes|N/A|MARIO A|Checksum complement.
`$70:008F`|96 bytes|`$7E:1EA2`|MARIO B|Overworld level setting flags.
`$70:00EF`|15 bytes|`$7E:1F02`|MARIO B|Overworld event flags, bitwise.
`$70:00FE`|1 byte|`$7E:1F11`|MARIO B|Current submap for Mario.
`$70:00FF`|1 byte|`$7E:1F12`|MARIO B|Current submap for Luigi.
`$70:0100`|4 bytes|`$7E:1F13`|MARIO B|Player animation on the overworld
`$70:0104`|2 bytes|`$7E:1F17`|MARIO B|Overworld X position of Mario.
`$70:0106`|2 bytes|`$7E:1F19`|MARIO B|Overworld Y position of Mario.
`$70:0108`|2 bytes|`$7E:1F1B`|MARIO B|Overworld X position of Luigi.
`$70:010A`|2 bytes|`$7E:1F1D`|MARIO B|Overworld Y position of Luigi.
`$70:010C`|2 bytes|`$7E:1F1F`|MARIO B|Pointer to Mario's overworld X position.
`$70:010E`|2 bytes|`$7E:1F21`|MARIO B|Pointer to Mario's overworld Y position.
`$70:0110`|2 bytes|`$7E:1F23`|MARIO B|Pointer to Luigi's overworld X position.
`$70:0112`|2 bytes|`$7E:1F25`|MARIO B|Pointer to Luigi's overworld Y position.
`$70:0114`|4 bytes|`$7E:1F27`|MARIO B|Switch block flags (Green, Yellow, Blue and Red).
`$70:0118`|3 bytes|`$7E:1F2B`|MARIO B|Empty. Cleared at reset and titlescreen load.
`$70:011B`|1 byte|`$7E:1F2E`|MARIO B|Number of events triggered.
`$70:011C`|2 bytes|N/A|MARIO B|Checksum complement.
`$70:011E`|96 bytes|`$7E:1EA2`|MARIO C|Overworld level setting flags.
`$70:017E`|15 bytes|`$7E:1F02`|MARIO C|Overworld event flags, bitwise.
`$70:018D`|1 byte|`$7E:1F11`|MARIO C|Current submap for Mario.
`$70:018E`|1 byte|`$7E:1F12`|MARIO C|Current submap for Luigi.
`$70:018F`|4 bytes|`$7E:1F13`|MARIO C|Player animation on the overworld
`$70:0193`|2 bytes|`$7E:1F17`|MARIO C|Overworld X position of Mario.
`$70:0195`|2 bytes|`$7E:1F19`|MARIO C|Overworld Y position of Mario.
`$70:0197`|2 bytes|`$7E:1F1B`|MARIO C|Overworld X position of Luigi.
`$70:0199`|2 bytes|`$7E:1F1D`|MARIO C|Overworld Y position of Luigi.
`$70:019B`|2 bytes|`$7E:1F1F`|MARIO C|Pointer to Mario's overworld X position.
`$70:019D`|2 bytes|`$7E:1F21`|MARIO C|Pointer to Mario's overworld Y position.
`$70:019F`|2 bytes|`$7E:1F23`|MARIO C|Pointer to Luigi's overworld X position.
`$70:01A1`|2 bytes|`$7E:1F25`|MARIO C|Pointer to Luigi's overworld Y position.
`$70:01A3`|4 bytes|`$7E:1F27`|MARIO C|Switch block flags (Green, Yellow, Blue and Red).
`$70:01A7`|3 bytes|`$7E:1F2B`|MARIO C|Empty. Cleared at reset and titlescreen load.
`$70:01AA`|1 byte|`$7E:1F2E`|MARIO C|Number of events triggered.
`$70:01AB`|2 bytes|N/A|MARIO C|Checksum complement.
`$70:01AD`|143 bytes|`$70:0000`|Copy|Contains a copy of "MARIO A" file, after saving. Last two bytes represent the checksum complement.
`$70:023C`|143 bytes|`$70:008F`|Copy|Contains a copy of "MARIO B" file, after saving. Last two bytes represent the checksum complement.
`$70:02CB`|143 bytes|`$70:011E`|Copy|Contains a copy of "MARIO C" file, after saving. Last two bytes represent the checksum complement.