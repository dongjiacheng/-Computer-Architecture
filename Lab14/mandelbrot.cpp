#include <xmmintrin.h>
#include "mandelbrot.h"

// cubic_mandelbrot() takes an array of SIZE (x,y) coordinates --- these are
// actually complex numbers x + yi, but we can view them as points on a plane.
// It then executes 200 iterations of f, using the <x,y> point, and checks
// the magnitude of the result; if the magnitude is over 2.0, it assumes
// that the function will diverge to infinity.

// vectorize the code below using SIMD intrinsics
int *
cubic_mandelbrot_vector(float x[SIZE], float y[SIZE]) {
    static int ret[SIZE];
    float temp1[4], temp2[4], temp3[4];
 
    __m128 acc, X_t, Y_t, X2_t,X2_temp, Y2_t, Xarray, Yarray, Array, magnitude;
    acc = _mm_set1_ps(0.0);
    magnitude = _mm_set1_ps(M_MAG);
    magnitude = _mm_mul_ps(magnitude, magnitude);

    for(int i=0; i<4; i++)
        temp3[i] = 3.0;

        Array = _mm_loadu_ps(temp3);

    for (int i = 0; i < SIZE; i += 4) {
       
        for(int k=0; k<4; k++){
            temp2[k] =0.0;
        }

        X_t = _mm_loadu_ps(temp2);
        Y_t = _mm_loadu_ps(temp2);

        X2_t =_mm_loadu_ps(temp2);
        X2_temp = _mm_loadu_ps(temp2);

        Y2_t = _mm_loadu_ps(temp2); 
        Xarray = _mm_loadu_ps(&x[i]);
        Yarray = _mm_loadu_ps(&y[i]);

        // Run M_ITER iterations
        for (int j = 0; j < M_ITER; j ++) {
            // Calculate x1^2 and y1^2
            //float x1_squared = x1 * x1;
            //float y1_squared = y1 * y1;

            X2_t = _mm_mul_ps(X_t, X_t);
            
            
            Y2_t = _mm_mul_ps(Y_t, Y_t);
    
           


            
            // Calculate the real piece of (x1 + (y1*i))^3 + (x + (y*i))
            //x2 = x1 * (x1_squared - 3 * y1_squared) + x[i];
            Y2_t = _mm_mul_ps(Array, Y2_t);
            X2_t = _mm_sub_ps(X2_t, Y2_t);
            X2_t = _mm_mul_ps(X2_t, X_t);
            X2_t = _mm_add_ps(X2_t, Xarray);

            X2_temp = X2_t;

            // Calculate the imaginary portion of (x1 + (y1*i))^3 + (x + (y*i))
            //y2 = y1 * (3 * x1_squared - y1_squared) + y[i];

             X2_t = _mm_mul_ps(X_t, X_t);
             Y2_t = _mm_mul_ps(Y_t, Y_t);

             X2_t = _mm_mul_ps(Array, X2_t);
             Y2_t = _mm_sub_ps(X2_t, Y2_t);
             Y2_t = _mm_mul_ps(Y_t, Y2_t);
             Y2_t = _mm_add_ps(Y2_t, Yarray);


            // Use the resulting complex number as the input for the next
            // iteration
            //x1 = x2;
            //y1 = y2;

            X_t = X2_temp;
            Y_t = Y2_t;
        }

        

        // caculate the magnitude of the result;
        // we could take the square root, but we instead just
        // compare squares

        X2_t = _mm_mul_ps(X2_t, X2_t);
        Y2_t = _mm_mul_ps(Y2_t, Y2_t);
        acc  = _mm_add_ps(X2_t, Y2_t);

         acc = _mm_cmplt_ps(acc, magnitude);
        _mm_storeu_ps(temp1, acc);
        ret[i] = temp1[0];
        ret[i+1] = temp1[1];
        ret[i+2] = temp1[2];
        ret[i+3] = temp1[3];
    }

    return ret;
}
