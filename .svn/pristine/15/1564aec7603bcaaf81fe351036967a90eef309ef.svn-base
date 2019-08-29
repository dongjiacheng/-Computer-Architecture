#include "cacheconfig.h"
#include "utils.h"
#include <math.h> 
#include <iostream>
using namespace std;

CacheConfig::CacheConfig(uint32_t size, uint32_t block_size, uint32_t associativity)
: _size(size), _block_size(block_size), _associativity(associativity) {
  /**
   * TODO
   * Compute and set `_num_block_offset_bits`, `_num_index_bits`, `_num_tag_bits`.
  */ 
 double offset = log2(block_size);
 int offset_bit = offset;

 if((double)offset_bit < offset)
 offset_bit = (int)(offset + 1);
 else
 offset_bit = offset;
 

 uint32_t block_num =  (size/block_size);
 uint32_t set_num = (block_num/associativity);
	 
 double index = log2(set_num);
 int index_num = index;
 if((double)index_num < index)
 index_num = (int)(index + 1);
 else
 	index_num = index;

 _num_block_offset_bits = offset_bit;
 _num_index_bits = index_num;
 //cout<<"index"<<_num_index_bits<<endl;
 //cout<<"offset"<<_num_block_offset_bits<<endl;

 _num_tag_bits = 32 - (offset_bit + index_num);
}
