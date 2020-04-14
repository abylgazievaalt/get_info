/******************************************************************************

  COMMENNTS HERE

******************************************************************************/

#ifndef GPULib
#define GPULib

#include <cuda.h>

# define cD2H cudaMemcpyDeviceToHost
# define cH2D cudaMemcpyHostToDevice

struct APopulation{

  unsigned int nBlocks;
  unsigned int nThreads;
  unsigned long N;

  int *dev_a;
  int *dev_b;
  int *dev_c;

};


APopulation initializePop(unsigned int numBlocks, unsigned int numThreads);
int runIter(APopulation *thePop);
void freeGPU(APopulation *thePop);

//__global__ void add(int *a, int *b, int *c);


#endif // GPULib
