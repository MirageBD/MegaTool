#ifndef _imgconvert_h_
#define _imgconvert_h_

#include "megatool.h"
#include "file.h"

bool imgconvert(File *aSource, File *aTarget, int width, int height, int channels);

#endif // _imgconvert_h_
