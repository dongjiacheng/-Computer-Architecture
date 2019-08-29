#include "cacheblock.h"

uint32_t Cache::Block::get_address() const {
int _num_block_offset_size = _cache_config.get_num_block_offset_bits();

int _num_index_size = _cache_config.get_num_index_bits();




uint32_t index = _index; 
uint32_t tag   = get_tag();


tag = tag << _num_index_size; 


tag += index;


tag  = tag << _num_block_offset_size; 


return tag;// TODO
  
}
