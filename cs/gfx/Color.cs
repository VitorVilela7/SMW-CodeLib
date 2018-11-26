using System;

class Color
{
	public static int EncodeSnesColor(int pcInput)
	{
		int r = (int)Math.Min(31, Math.Round(((pcInput >> 16) & 255) / 8.0));
		int g = (int)Math.Min(31, Math.Round(((pcInput >> 8) & 255) / 8.0));
		int b = (int)Math.Min(31, Math.Round(((pcInput >> 0) & 255) / 8.0));

		return r | g << 5 | b << 10;
	}

	public static Color[] ExtractPaletteColors(byte[] palData)
	{
		var paletteType = -1; // 0 = PAL, 2 = TPL, 1 = MW3

		switch (palData.Length)
		{
			case 768: paletteType = 0; break;
			case 514: paletteType = 1; break;
			case 516:
				if (palData[0] == (char)'T' &&
		  palData[1] == (char)'P' && palData[2] == (char)'L'
		  && palData[3] == 0x02) paletteType = 2; break;
		}

		if (paletteType == -1)
		{
			throw new Exception("Unknown palette type.");
		}

		Color[] output = new Color[256];

		for (int i = 0; i < 256; ++i)
		{
			output[i] = GetColor(ref palData, paletteType, i);
		}

		return output;
	}

	public static Color GetColor(ref byte[] palette, int paletteType, int n)
	{
		switch (paletteType)
		{
			case 0:
				n *= 3;
				return Color.FromArgb(palette[n], palette[n + 1], palette[n + 2]);

			case 1:
				n *= 2;
				return DecodeSNESColor(palette[n], palette[n + 1]);

			case 2:
				n *= 2;
				return DecodeSNESColor(palette[n + 4], palette[n + 5]);
		}

		throw new Exception();
	}

	public static Color DecodeSNESColor(int byte1, int byte2)
	{
		return Color.FromArgb((byte1 & 0x1F) << 3,
			((byte1 | (byte2 << 8)) >> 5 & 0x1F) << 3, (byte2 >> 2 & 0x1F) << 3);
	}
}