using System;

class BRR
{	
	static short[] DecBRR(byte[] binput)
	{
		List<short> output = new List<short>();
		int range, end = 0, loop, filter, counter, temp; // Size of these doesn't matter
		short input;               // These must be 16-bit
		int now = 0;                                   // Pointer to where we are in output[];

		int ii = 0;

		var GetNextByte = new Func<int>(delegate ()
		{
			if (ii == binput.Length) return 0;
			return binput[ii++];
		});

		output.Add(0); // the first two samples are null
		output.Add(0);
		now += 2;

		while (end == 0 && ii < binput.Length)
		{
			range = GetNextByte();     // Let's just put the header here for now
			end = range & 1;         // END bit is bit 0
			loop = range & 2;        // LOOP bit is bit 1
			filter = (range >> 2) & 3; // FILTER is bits 2 and 3
			range >>= 4;               // RANGE is the upper 4 bits

			for (counter = 0; counter < 8; counter++)
			{ // Get the next 8 bytes
				output.Add(0);
				temp = GetNextByte();                 // Wherever you want to get this from
				input = (short)(temp >> 4);                      // Get the first nibble of the byte
				input &= 0xF;
				if (input > 8)
				{                        // The nibble is negative, so make the 
					input |= unchecked((short)0xFFF0);                  // 16-bit value negative
				}
				output[now] = (short)(input << range);         // Apply the RANGE value

				// Filter processing goes here (explained later)
				if (filter == 1)
				{
					output[now] += (short)((double)output[now - 1] * 15 / 16);
				}
				else if (filter == 2)
				{
					output[now] += (short)(((double)output[now - 1] * 61 / 32) - ((double)output[now - 2] * 15 / 16));
				}
				else if (filter == 3)
				{
					output[now] += (short)(((double)output[now - 1] * 115 / 64) - ((double)output[now - 2] * 13 / 16));
				}

				output.Add(0);
				now++;                                // Advance our output pointer

				// Now do the same thing for the other nibble

				input = (short)(temp & 0xF);                   // Get the second nibble of the byte
				if (input > 8)
				{                        // The nibble is negative, so make the 
					input |= unchecked((short)0xFFF0);                  // 16-bit value negative
				}
				output[now] = (short)(input << range);         // Apply the RANGE value

				// Filter processing goes here (explained later)

				if (filter == 1)
				{
					output[now] += (short)((double)output[now - 1] * 15 / 16);
				}
				else if (filter == 2)
				{
					output[now] += (short)(((double)output[now - 1] * 61 / 32) - ((double)output[now - 2] * 15 / 16));
				}
				else if (filter == 3)
				{
					output[now] += (short)(((double)output[now - 1] * 115 / 64) - ((double)output[now - 2] * 13 / 16));
				}

				now++;                                // Advance our output pointer
			}
			// We're done with all 8 bytes, and if the END bit was present, we're done with the whole sample.
		}

		output.RemoveAt(0); // remove first null samples
		output.RemoveAt(0);
		return output.ToArray();
	}
}