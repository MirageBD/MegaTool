#include "megatool.h"
#include "gfx2code.h"
#include <stdio.h>
#include <stdlib.h>

bool gfx2code(File *aSource)
{
	uint x, y;

	int widthlo  = aSource->data[1];
	int widthhi  = aSource->data[0];
	int heightlo = aSource->data[3];
	int heighthi = aSource->data[2];

	int width = widthlo + (widthhi<<8);
	int height = heightlo + (heighthi<<8);

	// printf("\nimage width: %d", width);
	// printf("\nimage height: %d\n\n", height);

	byte b = 0;

	for(y = 0; y < height; y++)
	{
		printf("; ");
		for(x = 0; x < width; x++)
		{
			b = aSource->data[2+2+2+3*256 + y*width + x];
			printf("%3d ", b);
		}
		printf("\n");
	}

	printf("\n");

	printf("	lda ypos\n");
	printf("	sta zp:zp1+1\n");
	printf("	lda xpos\n");
	printf("	sta zp:zp1+0\n\n");

	for(y = 0; y < height; y++)
	{
		b = 0;
		int numleading0 = -1;
		while(b == 0 && numleading0 < width)
		{
			b = aSource->data[2+2+2+3*256 + y*width + numleading0 + 1];
			numleading0++;
		}

		b = 0;
		int newwidth = width+1;
		while(b == 0 && newwidth > 0)
		{
			b = aSource->data[2+2+2+3*256 + y*width + newwidth - 2];
			newwidth--;
		}

		printf("	ldz #%d\n", numleading0);

		for(x = numleading0; x < newwidth; x++)
		{
			b = aSource->data[2+2+2+3*256 + y*width + x];

			if(b != 0)
			{
				printf("	lda [zp:zp1],z\n");
				printf("	adc #%d\n", b);
				printf("	sta [zp:zp1],z\n");
			}

			if(x != newwidth-1)
				printf("	inz\n");
		}

		if(y != height-1)
			printf("	inc zp:zp1+1\n\n");
	}
	printf("\n");

	return true;    
}
