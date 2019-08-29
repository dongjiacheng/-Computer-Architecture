/**
 * @file
 * Contains the implementation of the extractMessage function.
 */

#include <iostream> // might be useful for debugging
#include <assert.h>
#include "extractMessage.h"

using namespace std;

char *extractMessage(const char *message_in, int length) {
   // length must be a multiple of 8
   assert((length % 8) == 0);
   int L = 0;
   // allocate an array for the output
   char *message_out = new char[length];
   //char out;
   int count = 0;
   int times = 0;
	// TODO: write your code here
   while(L < length)
   {
   	char answer[8];
   	for(int i = 0 ; i < 8 ; i++)
   	{
   		answer[i] = message_in[times*8+i];
   	}
//	for(int j = 0 ; j< 8; j++){
//   	char temp[8];
//   	for(int i = 0 ; i < 8 ; i++)
//   	{
       
	
//	message_out[count]+= temp[i];
 //  	}
 //
 
	for(int i = 0 ; i < 8; i++)
	{
	for(int j = 0; j < 8; j++)
	{
	message_out[j+L] += ((answer[i]>>j)&0x01)<<i;

	}
	}
	count++;
		
   
      times++;	
      L+=8;				
   								
   	}
   	
   

	return message_out;
}
