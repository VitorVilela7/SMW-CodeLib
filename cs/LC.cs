// Code for handling FuSoYa's Lunar Compress in C#

using System;
using System.Runtime.InteropServices;

namespace LunarCompress
{
    unsafe class LC
    {
        const string dll = "LC";

        [DllImport(dll)]
        public static extern uint LunarVersion();
        [DllImport(dll, CharSet = CharSet.Ansi)]
        public static extern bool LunarOpenFile(string FileName, uint FileMode);
        [DllImport(dll)]
        public static extern byte* LunarOpenRAMFile(void* data, uint FileMode, uint size);
        [DllImport(dll, CharSet = CharSet.Ansi)]
        public static extern uint LunarSaveRAMFile(string FileName);
        [DllImport(dll)]
        public static extern bool LunarCloseFile();
        [DllImport(dll)]
        public static extern uint LunarGetFileSize();
        [DllImport(dll)]
        public static extern uint LunarReadFile(void* Destination, uint Size, uint Address, uint Seek);
        [DllImport(dll)]
        public static extern uint LunarWriteFile(void* Source, uint Size, uint Address, uint Seek);
        [DllImport(dll)]
        public static extern uint LunarSetFreeBytes(uint value);
        [DllImport(dll)]
        public static extern uint LunarSNEStoPC(uint Pointer, uint ROMType, uint Header);
        [DllImport(dll)]
        public static extern uint LunarPCtoSNES(uint Pointer, uint ROMType, uint Header);
        [DllImport(dll)]
        public static extern uint LunarDecompress(void* Destination, uint AddressToStart, uint MaxDataSize, uint Format, uint Format2, uint* LastROMPosition);
        [DllImport(dll)]
        public static extern uint LunarRecompress(void* Source, void* Destination, uint DataSize, uint MaxDataSize, uint Format, uint Format2);
        [DllImport(dll)]
        public static extern bool LunarEraseArea(uint Address, uint Size);
        [DllImport(dll)]
        public static extern uint LunarExpandROM(uint Mbits);
        [DllImport(dll)]
        public static extern uint LunarVerifyFreeSpace(uint AddressStart, uint AddressEnd, uint Size, uint BankType);
        [DllImport(dll)]
        public static extern uint LunarIPSCreate(IntPtr hwnd, char* IPSFileName, char* ROMFileName, char* ROM2FileName, uint Flags);
        [DllImport(dll)]
        public static extern uint LunarIPSApply(IntPtr hwnd, char* IPSFileName, char* ROMFileName, uint Flags);
        [DllImport(dll)]
        public static extern bool LunarCreatePixelMap(void* Source, void* Destination, uint NumTiles, uint GFXType);
        [DllImport(dll)]
        public static extern bool LunarCreateBppMap(byte* Source, byte* Destination, uint NumTiles, uint GFXType);
        [DllImport(dll)]
        public static extern uint LunarSNEStoPCRGB(uint SNESColor);
        [DllImport(dll)]
        public static extern uint LunarPCtoSNESRGB(uint PCColor);
        [DllImport(dll)]
        public static extern bool LunarRender8x8(uint* TheMapBits, int TheWidth, int TheHeight, int DisplayAtX, int DisplayAtY, byte* PixelMap, uint* PCPalette, uint Map8Tile, uint Extra);
        [DllImport(dll)]
        public static extern uint LunarWriteRatArea(void* TheData, uint Size, uint PreferredAddress, uint MinRange, uint MaxRange, uint Flags);
        [DllImport(dll)]
        public static extern uint LunarEraseRatArea(uint Address, uint Size, uint Flags);
        [DllImport(dll)]
        public static extern uint LunarGetRatAreaSize(uint Address, uint Flags);
    }
}
