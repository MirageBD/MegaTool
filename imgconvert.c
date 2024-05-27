#include "imgconvert.h"
#include "cruncher.h"
#include <stdio.h>
#include <stdlib.h>

byte reversenibble(byte b)
{
	return (byte)((b >> 4) | ((b & 15) << 4));
}

bool imgconvert(File *aSource, File *aTarget, int width, int height, int channels)
{
	uint x, y;
	byte *target;

	uint ibufSize = aSource->size;

	printf("\nimage width: %d", width);
	printf("\nimage height: %d\n\n", height);

   	aTarget->size = ibufSize;
	aTarget->data = (byte*)malloc(aTarget->size);
	target = aTarget->data;

	if(channels == 3)
	{		
		for(y = 0; y < height; y++)
		{
			for(x = 0; x < width; x++)
			{
				byte r = aSource->data[y*width*3 + 3*x + 0];
				byte g = aSource->data[y*width*3 + 3*x + 1];
				byte b = aSource->data[y*width*3 + 3*x + 2];

				aTarget->data[(3*y+0)*width + x] = reversenibble(r);
				aTarget->data[(3*y+1)*width + x] = reversenibble(g);
				aTarget->data[(3*y+2)*width + x] = reversenibble(b);
			}
		}
	}
	else if(channels == 1)
	{
		for(y = 0; y < height; y++)
		{
			for(x = 0; x < width; x++)
			{
				byte r = aSource->data[y*width + x + 0];
				aTarget->data[y*width + x] = reversenibble(r);
			}
		}
	}

	return true;    
}
