using System;
using System.Collections.Generic;
using System.Text;
using System.IO;

namespace AntiSPC
{
    class Program
    {
        //static string outputFile;
        static int MusicOffset;
        //static int MusicAND = 0xFFFF;
        static byte[] spcData;
        static byte[] aram;
        static byte[] dsp;

        static ushort[] introPointers;
        static ushort[] mainPointers;
        static ushort currentPointer;

        static bool Intro;
        static bool Loop;
        static bool AM4Hacks;
        static bool RawNote;
        //static bool Indirect;

        static int ch;
        static bool introMode;

        static int engine;

        static List<int> loopPointers;

        static int[] redirectVCMD;

        static void Init()
        {
            redirectVCMD = new int[256];

            for (int i = 0; i < 256; ++i)
            {
                redirectVCMD[i] = i;
            }

            if (engine == 1) // AddmusicM
            {
                redirectVCMD[0xE6] = 0x02E6;
                redirectVCMD[0xF4] = 0x02F4;
                redirectVCMD[0xF8] = 0x02F8;
                redirectVCMD[0xF3] = 0x02F3;
                redirectVCMD[0xF5] = 0x02F5;
                redirectVCMD[0xF6] = 0x02F6;
                redirectVCMD[0xF7] = 0x02F7;
                redirectVCMD[0xFA] = 0x02FA;
            }
            else if (engine == 2) // AddmusicK
            {
                redirectVCMD[0xDB] = 0x4202-1;
                redirectVCMD[0xDC] = 0x4203-1;
                redirectVCMD[0xDD] = 0x4204-1;
                redirectVCMD[0xDE] = 0x4204-1;
                redirectVCMD[0xDF] = 0x4201-1;
                redirectVCMD[0xE0] = 0x4202-1;
                redirectVCMD[0xE1] = 0x4203-1;
                redirectVCMD[0xE2] = 0x4202-1;
                redirectVCMD[0xE3] = 0x4203-1;
                redirectVCMD[0xE4] = 0x4202-1;
                redirectVCMD[0xE5] = 0x4204-1;
                redirectVCMD[0xE6] = 0x4202-1;
                redirectVCMD[0xE7] = 0x4202-1;
                redirectVCMD[0xE8] = 0x4203-1;
                redirectVCMD[0xEA] = 0x4202-1;
                redirectVCMD[0xEB] = 0x4204-1;
                redirectVCMD[0xEC] = 0x4204-1;
                redirectVCMD[0xED] = 0x4203-1;
                redirectVCMD[0xEE] = 0x4202-1;
                redirectVCMD[0xEF] = 0x4204-1;
                redirectVCMD[0xF0] = 0x4201-1;
                redirectVCMD[0xF1] = 0x4204-1;
                redirectVCMD[0xF2] = 0x4204-1;
                redirectVCMD[0xF3] = 0x4203-1;
                redirectVCMD[0xF4] = 0x4202-1;
                redirectVCMD[0xF5] = 0x4209-1;
                redirectVCMD[0xF6] = 0x4203-1;
                redirectVCMD[0xF8] = 0x4202-1;
                redirectVCMD[0xF9] = 0x4203-1;
                redirectVCMD[0xFA] = 0x4203-1;
                redirectVCMD[0xFB] = 0x420-1; //length decided by $XX.
                redirectVCMD[0xFB] = 0x4204-1;
                redirectVCMD[0xFB] = 0x420-1; //length decided by number of $Z...
                redirectVCMD[0xFC] = 0x4203-1;
            }
                        //case 0x02E6:
                        //case 0x02F4:
                        //case 0x02F8:
                        //    Generic(1);
                        //    break;

                        //case 0x02F3:
                        //    Generic(2);
                        //    break;

                        //case 0x02F5:
                        //    Generic(8);
                        //    break;
                        //case 0x02F6:
                        //    Generic(2);
                        //    break;
                        //case 0x02F7:
                        //    Generic(3);
                        //    break;
        }

        public static string MainCode(byte[] spc, int engine, int musicOffset)
        {
            Program.engine = engine;

            Init();
            Welcome(spc);
			if (musicOffset != -1)
				MusicOffset = musicOffset;
            GetPointers();

            StringBuilder output = new StringBuilder();

            if (!Loop)
            {
                output.AppendLine("?0");
            }

            output.AppendLine();

            loopPointers = new List<int>();

            for (ch = 0; ch < 8; ++ch)
            {
                if (introPointers != null)
                {
                    if (introPointers[ch] == 0 && mainPointers[ch] == 0)
                    {
                        continue;
                    }
                }
                else if (mainPointers[ch] == 0)
                {
                    continue;
                }

                output.AppendFormat("#{0} ", ch);

                if (Intro && introPointers[ch] != 0)
                {
                    introMode = true;
                    currentPointer = introPointers[ch];
                    output.Append(ReadVCMD());
                    output.Append("/");
                }
                //if (true||currentPointer != 0)
                {
                    introMode = false;
                    currentPointer = mainPointers[ch];
                    output.Append(ReadVCMD());
                    output.AppendLine();
                    output.AppendLine();
                }
            }

            //File.WriteAllText(outputFile, output.ToString());

            return output.ToString();
        }

        static string Generic(int length)
        {
            string output = String.Format("${0:X2} ", aram[currentPointer - 1]);

            for (int i = 0; i < length; ++i)
            {
                output += String.Format("${0:X2} ", aram[currentPointer++]);
            }

            return output;
        }

        static string ReadVCMD()
        {
            StringBuilder str = new StringBuilder();
            string[] notes = new string[] { "c", "c+", "d", "d+",
                "e", "f", "f+", "g", "g+", "a", "a+", "b" };
            string[] tieRest = new string[] { "^", "r" };

            int octave = -1; // o4

            bool sub = false;
            int ret = 0;
            int times = 0;

            int noteValue = 0;

            bool waiting = false;

            while (true)
            {
                if (introMode && currentPointer == mainPointers[ch])
                {
                    break;
                }

                int vcmd = redirectVCMD[aram[currentPointer++]];

                if (vcmd == 0)
                {
                    if (sub)
                    {
                        currentPointer = (ushort)ret;
                        ret = 0;
                        sub = false;
                        str.Append("]");

                        if (times != 1)
                        {
                            str.Append(times);
                        }
                    }
                    else break;
                }
                else if (vcmd >= 0x01 && vcmd <= 0x7F)
                {
                    // Note Parameter
                    if (RawNote)
                    {
                        str.AppendFormat("${0:X2}", vcmd);
                        continue;
                    }
                    
                    if (waiting)
                    {
                        if (192 % vcmd == 0 && vcmd <= 192)
                            str.AppendFormat("{0}", 192 / vcmd);
                        else
                            str.AppendFormat("={0}", vcmd);

                        waiting = false;

                        if (aram[currentPointer++] >= 0x01 && aram[currentPointer - 1] <= 0x7F)
                            noteValue = aram[currentPointer];
                        else
                            noteValue = vcmd;
                    }
                    else
                        noteValue = vcmd;

                    if (aram[currentPointer] >= 0x01 && aram[currentPointer] <= 0x7F)
                        str.AppendFormat("q{0:X2} ", aram[currentPointer++]);
                }
                else if ((vcmd >= 0x80 && vcmd <= 0xC5) ||
                         (vcmd >= 0xD0 && vcmd <= 0xD9) ||
                          vcmd == 0xC6 || vcmd == 0xC7)
                {
                    if (RawNote)
                    {
                        str.AppendFormat("${0:X2}", vcmd);
                        continue;
                    }

                    if (vcmd >= 0xD0) //Perc. Note
                    {
                        vcmd -= 0xD0 - 21;
                        str.AppendFormat("@{0}c", vcmd);
                    }
                    else if (vcmd <= 0xc5) // Note
                    {
                        vcmd -= 0x80;

                        if (octave != (vcmd / 12))
                        {
                            int new_octave = vcmd / 12;

                            //if (octave + 1 == new_octave)
                            //    str.Append(">");
                            //else if (octave - 1 == new_octave)
                            //    str.Append("<");
                            //else
                                str.AppendFormat("o{0}", new_octave + 1);

                            octave = new_octave;
                        }

                        str.AppendFormat("{0}", notes[vcmd % 12]);
                    }
                    else
                    {
                        str.AppendFormat("{0}", tieRest[vcmd - 0xC6]);
                    }

                    if (noteValue == 0)
                        waiting = true;
                    else if (192 % noteValue == 0 && noteValue <= 192)
                        str.AppendFormat("{0}", 192 / noteValue);
                    else
                        str.AppendFormat("={0}", noteValue);
                }
                else
                {
                    switch (vcmd)
                    {
                        case 0xE2:
                        case 0xE7:
                        case 0xE0:
                            break;

                        default:
                            str.AppendLine();
                            break;
                    }

                    switch (vcmd)
                    {
                        case 0xDA: // Instrument
                            str.AppendFormat("$DA ${0:X2} ", aram[currentPointer++]);
                            break;

                        case 0xDB: // Pan
                            int j = aram[currentPointer++];
                            if (j <= 20)
                            {
                                str.AppendFormat("y{0} ", j);
                            }
                            else
                            {
                                str.AppendFormat("$DB ${0:X2} ", j);
                            }
                            break;

                        case 0xDC: // Pan Fade
                            str.AppendFormat("$DC ${0:X2} ${1:X2} ",
                                aram[currentPointer++], aram[currentPointer++]);
                            break;

                        case 0xDD: // Pitch Slide (XX YY ZZ)
                            str.AppendFormat("$DD ${0:X2} ${1:X2} ${2:X2} ", aram[currentPointer++],
                                aram[currentPointer++], aram[currentPointer++]);
                            break;

                        case 0xDE: // Vibrato (XX YY ZZ)
                            str.AppendFormat("$DE ${0:X2} ${1:X2} ${2:X2} ", aram[currentPointer++],
                                aram[currentPointer++], aram[currentPointer++]);
                            break;

                        case 0xDF: // Vibrato Off
                            str.AppendFormat("$DF ");
                            break;

                        case 0xE0: // Master Volume (XX)
                            str.AppendFormat("w{0} ", aram[currentPointer++]);
                            break;

                        case 0xE1: // Master Volume Fade (XX YY)
                            str.AppendFormat("$E1 ${0:X2} ${1:X2} ",
                                aram[currentPointer++], aram[currentPointer++]);
                            break;

                        case 0xE2: // Tempo (XX)
                            str.AppendFormat("t{0} ", aram[currentPointer++]);
                            break;

                        case 0xE3: // Tempo Fade (XX YY)
                            str.AppendFormat("$E3 ${0:X2} ${1:X2} ",
                                aram[currentPointer++], aram[currentPointer++]);
                            break;

                        case 0xE4: // Global Transpose (XX)
                            str.AppendFormat("$E4 ${0:X2} ", aram[currentPointer++]);
                            break;

                        case 0xE5: // Tremolo On (XX YY ZZ)
                            j = 0;

                            if (AM4Hacks)
                            {
                                if (aram[currentPointer] >= 0x80)
                                {
                                    j = 1;
                                    str.AppendFormat("$E5 ${0:X2} ${1:X2} ",
                                        aram[currentPointer++], aram[currentPointer++]);
                                }
                            }

                            if (j == 0)
                            {
                                str.AppendFormat("$E5 ${0:X2} ${1:X2} ${2:X2} ", aram[currentPointer++],
                                    aram[currentPointer++], aram[currentPointer++]);
                            }
                            break;

                        case 0xE6: // Tremolo Off
                            str.AppendFormat("$E6 ");
                            break;

                        case 0xE7: // Volume (XX)
                            str.AppendFormat("v{0}", aram[currentPointer++]);
                            break;

                        case 0xE8: // Volume Fade (XX YY)
                            str.AppendFormat("$E8 ${0:X2} ${1:X2} ",
                                aram[currentPointer++], aram[currentPointer++]);
                            break;

                        case 0xE9: // Call subroutine... Loop! (XX YY ZZ)
                            if (sub) break;

                            int loopOffset = aram[currentPointer++] | (aram[currentPointer++] << 8);
                            j = loopPointers.IndexOf(loopOffset);

                            if (j > -1)
                            {
                                str.AppendFormat("({0})", j + 1);

                                if (aram[currentPointer++] != 1)
                                {
                                    str.Append(aram[currentPointer - 1]);
                                }
                            }
                            else
                            {
                                str.AppendFormat("({0})[", loopPointers.Count + 1);
                                loopPointers.Add(loopOffset);

                                times = aram[currentPointer++];
                                sub = true;
                                ret = currentPointer;

                                currentPointer = (ushort)loopOffset;
                            }
                            break;

                        case 0xEA: // Vibrato Fade (XX)
                            str.AppendFormat("$EA ${0:X2} ", aram[currentPointer++]);
                            break;

                        case 0xEB: // Pitch Envelope To (XX YY ZZ)
                            str.AppendFormat("$EB ${0:X2} ${1:X2} ${2:X2} ", aram[currentPointer++],
                                aram[currentPointer++], aram[currentPointer++]);
                            break;

                        case 0xEC: // Pitch Envelope From (XX YY ZZ)
                            str.AppendFormat("$EC ${0:X2} ${1:X2} ${2:X2} ", aram[currentPointer++],
                                aram[currentPointer++], aram[currentPointer++]);
                            break;

                        case 0xED: // (Undefined) Pitch Envelope Off (Code Exists, but Never Reached)
                            if (AM4Hacks)
                            {
                                if (aram[currentPointer] < 0x80)
                                {
                                    str.AppendFormat("$ED ${0:X2} ${1:X2} ",
                                        aram[currentPointer++], aram[currentPointer++]);
                                }
                                else
                                {
                                    switch (aram[currentPointer] - 0x80)
                                    {
                                        case 0x00: // Direct DSP Write (80 XX YY)
                                            str.AppendFormat("$ED ${0:X2} ${1:X2} ${2:X2} ", aram[currentPointer++],
                                                aram[currentPointer++], aram[currentPointer++]);
                                            break;

                                        case 0x01: // H-tune? (81 XX)
                                            str.AppendFormat("$ED ${0:X2} ${1:X2} ",
                                                aram[currentPointer++], aram[currentPointer++]);
                                            break;

                                        case 0x02: // Spc code write (82/83 XX YY ZZ WW [ZZWW+1])
                                        case 0x03:
                                            str.AppendFormat("$ED ${0:X2} ${1:X2} ${2:X2} ${3:X2} ${4:X2}",
                                                aram[currentPointer++], aram[currentPointer++],
                                                aram[currentPointer++], aram[currentPointer++],
                                                aram[currentPointer++]);

                                            int steps = aram[currentPointer - 1] | (aram[currentPointer - 2] << 8);
                                            ++steps;

                                            for (int i = 0; i < steps; ++i)
                                            {
                                                str.AppendFormat(" ${0:X2}", aram[currentPointer++]);
                                            }

                                            str.Append(" ");
                                            break;
                                    }

                                }
                            }
                            else
                            {
                                str.AppendFormat("$ED ");
                            }
                            break;

                        case 0xEE: // Tuning (XX)
                            str.AppendFormat("$EE ${0:X2} ", aram[currentPointer++]);
                            break;

                        case 0xEF: // Echo VBits / Volume (XX YY ZZ)
                            str.AppendFormat("$EF ${0:X2} ${1:X2} ${2:X2} ", aram[currentPointer++],
                                aram[currentPointer++], aram[currentPointer++]);
                            break;

                        case 0xF0: // Echo Off
                            str.AppendFormat("$F0 ");
                            break;

                        case 0xF1: // Echo Parameters (XX YY ZZ)
                            str.AppendFormat("$F1 ${0:X2} ${1:X2} ${2:X2} ", aram[currentPointer++],
                                aram[currentPointer++], aram[currentPointer++]);
                            break;

                        case 0xF2: // Echo Volume Fade (XX YY ZZ)
                            str.AppendFormat("$F2 ${0:X2} ${1:X2} ${2:X2} ", aram[currentPointer++],
                                aram[currentPointer++], aram[currentPointer++]);
                            break;

                        // AMK stuff
                        case 0x4200:
                            str.Append(Generic(0));
                            break;
                        case 0x4201: // generic length
                            str.Append(Generic(1));
                            break;
                        case 0x4202:
                            str.Append(Generic(2));
                            break;
                        case 0x4203:
                            str.Append(Generic(3));
                            break;
                        case 0x4204:
                            str.Append(Generic(4));
                            break;
                        case 0x4205:
                            str.Append(Generic(5));
                            break;
                        case 0x4206:
                            str.Append(Generic(6));
                            break;
                        case 0x4207:
                            str.Append(Generic(7));
                            break;
                        case 0x4208:
                            str.Append(Generic(8));
                            break;

                        // AMM Stuff
                        case 0x02E6:
                        case 0x02F4:
                        case 0x02F8:
                        case 0x02FA:
                            str.Append(Generic(1));
                            break;

                        case 0x02F3:
                            str.Append(Generic(2));
                            break;

                        case 0x02F5:
                            str.Append(Generic(8));
                            break;
                        case 0x02F6:
                            str.Append(Generic(2));
                            break;
                        case 0x02F7:
                            str.Append(Generic(3));
                            break;


                        // Tetris Attack Hacks
                        case 0x01F4:
                            str.AppendFormat(";$F4 ${0:X2} ", aram[currentPointer++]);
                            str.AppendLine();
                            break;

                        case 0x01F5:
                            str.AppendFormat(";$F5 ");
                            str.AppendLine();
                            break;
                        case 0x01F6:
                            str.AppendFormat(";$F6 ");
                            str.AppendLine();
                            break;
                        case 0x01F7:
                            str.AppendFormat(";$F7 ${0:X2} ${1:X2}",
                                aram[currentPointer++], aram[currentPointer++]);
                            str.AppendLine();
                            break;
                        case 0x01F8:
                            // arg1: unknown
                            // arg2: gain
                            currentPointer++;
                            str.AppendFormat("$ED $80 ${1:X2} ${0:X2} ", (ch << 4) + 7, aram[currentPointer++]);
                            //str.AppendFormat(";$F8 ${0:X2} ${1:X2}",
                            //    aram[currentPointer++], aram[currentPointer++]);
                            //str.AppendLine();
                            break;
                        case 0x01F9:
                            str.AppendFormat(";$F9");
                            str.AppendLine();
                            break;
                        case 0x01FA:
                            // VCMD: $FA
                            // If positive, skip 4*arg1 bytes from vcmd data.
                            // instead of N-SPC engine do this, let AntiSPC do that and nothing else.
                            j = aram[currentPointer++];

                            if ((j & 0x80) == 0)
                            {
                                currentPointer += (ushort)(j * 4);
                            }
                            else
                            {
                                str.AppendFormat(";$FA ${0:X2}", j);
                                str.AppendLine();
                            }
                            break;
                        case 0x01FB:
                            str.AppendFormat(";$FB ${0:X2}",
                                aram[currentPointer++]);
                            str.AppendLine();
                            break;
                        case 0x01FC:
                            // Another VCMD that does strange stuff.
                            // But it skip bytes again, so...
                            j = aram[currentPointer++];
                            // skip (((arg1 & 15) + 1) * 3) bytes

                            currentPointer += (ushort)(((j & 15) + 1) * 3);

                            //str.AppendFormat(";$FC ${0:X2}",
                            //    aram[currentPointer++]);
                            //str.AppendLine();
                            break;
                        case 0x01FD:
                            str.AppendFormat(";$FD ${0:X2}",
                                aram[currentPointer++]);
                            str.AppendLine();
                            break;


//                            ; vcmd lengths ($0ab2)
//0b0c: db         $01,$01,$02,$03,$00,$01 ; da-df
//0b12: db $02,$01,$02,$01,$01,$03,$00,$01 ; e0-e7
//0b1a: db $02,$03,$01,$03,$03,$00,$01,$03 ; e8-ef
//0b22: db $00,$03,$03,$03, $01,$00,$00,$02 ; f0-f7
//0b2a: db $02,$00,$01,$01,$01,$01         ; f8-fd

                        case 0xED81: // Per-voice Transpose = $ED $81
                            str.AppendFormat("$ED $81 ${0:X2} ", aram[currentPointer++]);
                            break;

                        case 0x01CA:
                        case 0x01CB:
                        case 0x01CC:
                        case 0x01CD:
                        case 0x01CE:
                        case 0x01CF:
                            str.AppendLine();
                            str.AppendFormat("; UP: {0:X2}~", vcmd & 0xff);
                            if (noteValue == 0)
                                waiting = true;
                            else if (192 % noteValue == 0 && noteValue <= 192)
                                str.AppendFormat("{0}", 192 / noteValue);
                            else
                                str.AppendFormat("={0}", noteValue);
                            str.AppendLine();
                            break;

                        case 0x01C6:
                            str.Append("$ED $81 $01 o6a"); octave = 5;
                            if (noteValue == 0)
                                waiting = true;
                            else if (192 % noteValue == 0 && noteValue <= 192)
                                str.AppendFormat("{0}", 192 / noteValue);
                            else
                                str.AppendFormat("={0}", noteValue);
                            break;

                        case 0x01C7:
                            str.Append("$ED $81 $02 o6a"); octave = 5;
                            if (noteValue == 0)
                                waiting = true;
                            else if (192 % noteValue == 0 && noteValue <= 192)
                                str.AppendFormat("{0}", 192 / noteValue);
                            else
                                str.AppendFormat("={0}", noteValue);
                            break;

                        default:
                            str.AppendFormat(";Unknown: ${0:X2}", aram[currentPointer - 1]);
                            str.AppendLine();
                            break;
                    }
                }
            }

            return str.ToString();
        }

        static int ReadARAM(int offset)
        {
            return aram[offset + 1] << 8 | aram[offset];
        }

        static void GetPointers()
        {
            /* How to get pointers:
             * 1. Read a word value at MusicOffset. This should point to some vectors.
             * 2. Then, read the value that is pointed. You should see this diagram:
             * [INTRO POINTER] [MAIN POINTER] [00FF] [MAIN POINTER]
             * And a pointer will have:
             * [CHANNEL 1][2][3][4][5][6][7][8]
            */

            #region Read Vectors
            int musicVector;

            //if (Indirect)
            //{
            //    musicVector = ReadARAM(MusicOffset);
            //    musicVector &= MusicAND;
            //}
            //else
            //{
                musicVector = ReadARAM(MusicOffset);
            //}

            // AMK annoyance
            if (engine == 2)
            {
				//F6 XX XX 2D C4 40
                musicVector = -1;

				for (int i = 0; i < 0x10000 - 5; ++i)
				{
					if (aram[i] == 0xF6 && aram[i + 3] == 0x2D && aram[i + 4] == 0xC4 && aram[i + 5] == 0x40)
					{
						int d = ReadARAM(i + 1);
						//VilelaBotApp.BotHandler.LastError += "\r\n" + i.ToString("X") + ": " + d.ToString("X");
						if (d == 0) continue;
						musicVector = ReadARAM( d + 0x0A * 2);
						break;
					}
				}
            }

			//VilelaBotApp.BotHandler.LastError += "\r\n" + musicVector.ToString("X");

            int pointer1 = ReadARAM(musicVector);
            int pointer2 = ReadARAM(musicVector + 2);
            int pointer3 = ReadARAM(musicVector + 4);
            int pointer4 = ReadARAM(musicVector + 6);

			//VilelaBotApp.BotHandler.LastError += "\r\n" + pointer1.ToString("X");
			//VilelaBotApp.BotHandler.LastError += "\r\n" + pointer2.ToString("X");
			//VilelaBotApp.BotHandler.LastError += "\r\n" + pointer3.ToString("X");
			//VilelaBotApp.BotHandler.LastError += "\r\n" + pointer4.ToString("X");

            int introPointer = 0;
            int mainPointer = 0;

            bool loop = true, intro = false;

            if (pointer1 == pointer2 || pointer2 == 255 || pointer2 == 0)
            {
                // song doesn't have intro.
                mainPointer = pointer1;
                introPointer = 0;

                if (pointer1 == pointer2)
                {
                    loop = pointer3 == 255;
                }
                else
                {
                    loop = pointer2 == 255;
                }
            }
            else if (pointer3 == 0x00ff)
            {
                // song have intro and loop.
                introPointer = pointer1;
                mainPointer = pointer2;
                intro = true;
            }
            else
            {
                // song have intro but loop.
                introPointer = pointer1;
                mainPointer = pointer2;
                loop = false;
                intro = true;
            }
            #endregion

            #region Copy Pointers
            Program.Intro = intro;
            Program.Loop = loop;

            if (intro)
            {
                introPointers = new ushort[8];

                for (int i = 0; i < 8; ++i)
                {
                    introPointers[i] = (ushort)ReadARAM(introPointer + i * 2);
                }
            }

            mainPointers = new ushort[8];

            for (int i = 0; i < 8; ++i)
            {
                mainPointers[i] = (ushort)ReadARAM(mainPointer + i * 2);
            }
            #endregion
        }

        static void Pause()
        {
            throw new Exception("Unknown Error.");
            //Console.Write("Press any key to continue...");
            //Console.ReadKey(true);
        }

        static bool Welcome(byte[] spc)
        {
            //// Usage: antispc spcfile instrucions
            //if (args.Length != 3)
            //{
            //    Console.WriteLine("AntiSPC v1.00 by Vitor Vilela");
            //    Console.WriteLine("Usage: antispc spcfile outputfile format.ini");
            //    Console.WriteLine("format.ini should point to a .ini file with configurations");
            //    Pause();
            //    return false;
            //}

            //if (!File.Exists(Path.GetFullPath(args[0])) || !File.Exists(Path.GetFullPath(args[2])))
            //{
            //    Console.WriteLine("One or more files doesn't exists!");
            //    Pause();
            //    return false;
            //}

//            [AntiSPC]
//Hacks=TRUE			# Use MORE.bin commands?
//Offset=13A0
//Notes=NORMAL			# NORMAL or RAW notes?

            AM4Hacks = true;
            MusicOffset = 0x13A0;
            RawNote = false;

            //IniParse ini = new IniParse(Path.GetFullPath(args[2]));
            //MusicOffset = ini.IniHexRead("AntiSPC", "Offset");

            //if (MusicOffset >= 0x10000 || MusicOffset == 0)
            //{
            //    Console.WriteLine("Invalid Music offset!");
            //    Pause();
            //    return false;
            //}

            //AM4Hacks = ini.IniReadValue("AntiSPC", "Hacks").ToLower() == "true";
            //Indirect = ini.IniReadValue("AntiSPC", "Indirect").ToLower() == "true";
            //RawNote = ini.IniReadValue("AntiSPC", "Notes").ToLower() == "raw";
            //MusicOffset += 2 * ini.IniIntRead("AntiSPC", "MusicIndex");

            //if (Indirect)
            //{
            //    MusicAND = ini.IniHexRead("AntiSPC", "MusicFilter");
            //}

            //for (int i = 0; i < 256; ++i)
            //{
            //    int j = ini.IniHexRead("AntiSPC", string.Format("Reloc{0:X2}", i));

            //    if (j != 0)
            //    {
            //        redirectVCMD[i] = j;
            //    }
            //}

            spcData = spc;//File.ReadAllBytes(Path.GetFullPath(args[0]));

            if (!IsValidSPC(spcData))
            {
                throw new Exception("Invalid SPC File!");
                //Console.WriteLine("Invalid SPC file!");
                //Pause();
                //return false;
            }

            //outputFile = Path.GetFullPath(args[1]);

            dsp = new byte[128];
            aram = new byte[0x10000];

            Array.Copy(spcData, 0x100, aram, 0, 65536);
            Array.Copy(spcData, 0x100, dsp , 0, 128);
            return true;
        }

        static bool IsValidSPC(byte[] spc)
        {
            if (spc.Length < 66048) return false;
            byte[] header = new byte[] {
                0x53, 0x4E, 0x45, 0x53, 0x2D, 0x53, 0x50, 0x43, 0x37, 0x30, 0x30,
                0x20, 0x53, 0x6F, 0x75, 0x6E, 0x64, 0x20, 0x46, 0x69, 0x6C, 0x65,
                0x20, 0x44, 0x61, 0x74, 0x61, 0x20, 0x76, 0x30, 0x2E, 0x33, 0x30
            };

            for (int i = 0; i < header.Length; ++i)
            {
                if (spc[i] != header[i]) return false;
            }

            return true;
        }
    }
}
