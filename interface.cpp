/******************************************************************************

  COMMENTS, AUTHORSHIP, TODO ETC. GOES HERE

/******************************************************************************/
#include <stdio.h>
#include "gpu.h"


/******************************************************************************/
int main(){

  APopulation thePop;

  thePop = initializePop(65000, 1);

  if(runIter(&thePop)) printf("error running runIter\n");

  freeGPU(&thePop);

  return 0;
}
