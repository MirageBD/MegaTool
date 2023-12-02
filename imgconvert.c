#include "imgconvert.h"
#include "cruncher.h"
#include <stdio.h>
#include <stdlib.h>

byte reversenibble(byte b)
{
	return (byte)((b >> 4) | ((b & 15) << 4));
}

bool imgconvert(File *aSource, File *aTarget)
{
	uint x, y;
	byte *target;

	uint ibufSize = aSource->size;

   	aTarget->size = ibufSize;
	aTarget->data = (byte*)malloc(aTarget->size);
	target = aTarget->data;

	for(y = 0; y < 200; y++)
	{
    	for(x = 0; x < 320; x++)
	    {
            byte r = aSource->data[y*320*3 + 3*x + 0];
            byte g = aSource->data[y*320*3 + 3*x + 1];
            byte b = aSource->data[y*320*3 + 3*x + 2];

		    aTarget->data[(3*y+0)*320 + x] = reversenibble(r);
		    aTarget->data[(3*y+1)*320 + x] = reversenibble(g);
		    aTarget->data[(3*y+2)*320 + x] = reversenibble(b);
        }
	}

	return true;    
}
