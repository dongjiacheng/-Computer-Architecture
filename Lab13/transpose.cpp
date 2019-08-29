#include <algorithm>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "transpose.h"

// will be useful
// remember that you shouldn't go over SIZE
using std::min;

// modify this function to add tiling
void
transpose_tiled(int **src, int **dest) {
     int blocksize = 32;

    for (int i = 0; i < SIZE; i += blocksize) {

        for (int j = 0; j < SIZE; j += blocksize) {
            
		for(int x = i; x< min(i+blocksize,SIZE); x++)
		 {
			for(int y = j; y< min(j+blocksize,SIZE);y++)		
			dest[x][y] = src[y][x];
		}        
	}

    }
}
