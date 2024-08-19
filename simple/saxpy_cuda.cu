#include <stdio.h>
#include <math.h>
#include <assert.h>

#define CUDA_ASSERT(x) (assert((x)==cudaSuccess))

__global__
void saxpy(int n, float a, float *x, float *y)
{
  int i = blockIdx.x*blockDim.x + threadIdx.x;
  if (i < n) y[i] = a*x[i] + y[i];
}

int main(void)
{
  int N = 1<<20;
  float *x, *y, *d_x, *d_y;
  x = (float*)malloc(N*sizeof(float));
  y = (float*)malloc(N*sizeof(float));

  CUDA_ASSERT(cudaMalloc(&d_x, N*sizeof(float)));
  CUDA_ASSERT(cudaMalloc(&d_y, N*sizeof(float)));

  for (int i = 0; i < N; i++) {
    x[i] = 1.0f;
    y[i] = 2.0f;
  }

  CUDA_ASSERT(cudaMemcpy(d_x, x, N*sizeof(float), cudaMemcpyHostToDevice));
  CUDA_ASSERT(cudaMemcpy(d_y, y, N*sizeof(float), cudaMemcpyHostToDevice));

  // Perform SAXPY on 1M elements
  saxpy<<<(N+255)/256, 256>>>(N, 2.0f, d_x, d_y);

  CUDA_ASSERT(cudaMemcpy(y, d_y, N*sizeof(float), cudaMemcpyDeviceToHost));

  float maxError = 0.0f;
  for (int i = 0; i < N; i++)
    maxError = ( maxError > abs(y[i]-4.0f) ) ? maxError : abs(y[i]-4.0f) ;
  printf("Max error: %f\n", maxError);

  CUDA_ASSERT(cudaFree(d_x));
  CUDA_ASSERT(cudaFree(d_y));
  free(x);
  free(y);
}
