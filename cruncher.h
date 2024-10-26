#ifndef _cruncher_h_
#define _cruncher_h_

#include "megatool.h"
#include "file.h"

bool crunch(File *aSource, File *aTarget, uint startAddress, bool isExecutable, bool isRelocated, uint startAddressSize);

#endif // _cruncher_h_
