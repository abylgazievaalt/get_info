/******************************************************************************

  usage information and TODO stuff here...

******************************************************************************/


#include <stdio.h>
#include "gpu.h"

/******************************************************************************/
APopulation initializePop(unsigned int numBlocks, unsigned int numThreads){

  APopulation thePop;

  thePop.nBlocks = numBlocks;
  thePop.nThreads = numThreads;
  thePop.N = numBlocks * numThreads;

  cudaMalloc( (void**) &thePop.dev_a, thePop.N*sizeof(int));
  cudaMalloc( (void**) &thePop.dev_b, thePop.N*sizeof(int));
  cudaMalloc( (void**) &thePop.dev_c, thePop.N*sizeof(int));

  //----- placeholder for initializing memory with values
  int a[thePop.N], b[thePop.N];
  for (int i=0; i<thePop.N; i++){
    a[i] = -i;
    b[i] = i*i;
  }
  cudaMemcpy(thePop.dev_a, a, thePop.N*sizeof(int), cH2D);
  cudaMemcpy(thePop.dev_b, b, thePop.N*sizeof(int), cH2D);
  // ------------------------

  return thePop;
}


/******************************************************************************/
__global__ void add(int *a, int *b, int *c){

  int tid = threadIdx.x + (blockIdx.x * blockDim.x);

  c[tid] = a[tid] + b[tid];

}

/******************************************************************************/
int runIter(APopulation *thePop){

  add <<< thePop->nBlocks, thePop->nThreads >>>
                                (thePop->dev_a, thePop->dev_b, thePop->dev_c);

  // -- crud...
  int a[thePop->N], b[thePop->N], c[thePop->N];
  cudaMemcpy(&a, thePop->dev_a, thePop->N * sizeof(int), cD2H);
  cudaMemcpy(&b, thePop->dev_b, thePop->N * sizeof(int), cD2H);
  cudaMemcpy(&c, thePop->dev_c, thePop->N * sizeof(int), cD2H);

  for(int i = 0; i< thePop->N; i++){
    printf("%d + %d = %d\n", a[i], b[i], c[i]);
    }
  // ----

  return 0;
}


/******************************************************************************/
void freeGPU(APopulation *thePop)
{
  cudaFree(thePop->dev_a);
  cudaFree(thePop->dev_b);
  cudaFree(thePop->dev_c);
}

/******************************************************************************/
